// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// Interfaz para interactuar con tokens ERC20
interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
}

// Contrato principal para gestionar depósitos y distribución de tokens ERC20
contract DepositoERC20 {
    // Dirección del propietario del contrato
    address public owner;

    // Token ERC20 con el que se va a interactuar
    IERC20 public token;

    // Cantidad total de tokens depositados en el contrato
    uint256 public totalDeposited;

    // Tiempo en el que los tokens pueden ser liberados
    uint256 public releaseTime;

    // Tiempo de espera antes de que los tokens puedan ser distribuidos
    uint256 public constant WAIT_TIME = 4 weeks;

    // Mapeo para verificar si una dirección está autorizada a depositar
    mapping(address => bool) public isAuthorized;

    // Mapeo para llevar un registro de los depósitos por dirección
    mapping(address => uint256) public deposits;

    // Lista de direcciones que recibirán tokens después del tiempo de espera
    address[] public whiteList;

    // Modificador para restringir el acceso solo al propietario del contrato
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Modificador para restringir el acceso solo a direcciones autorizadas
    modifier onlyAuthorized() {
        require(
            isAuthorized[msg.sender],
            "Not authorized to perform this action"
        );
        _;
    }

    // Modificador para asegurar que la función solo se llame después del tiempo de liberación
    modifier afterReleaseTime() {
        require(block.timestamp >= releaseTime, "Release time not reached");
        _;
    }

    // Constructor para inicializar el contrato con la dirección del token ERC20
    constructor(address _token) {
        owner = msg.sender;
        token = IERC20(_token);
    }

    // Autorizar a una dirección a depositar tokens
    function authorizeAccount(address account) external onlyOwner {
        isAuthorized[account] = true;
    }

    // Revocar la autorización a una dirección
    function revokeAuthorization(address account) external onlyOwner {
        isAuthorized[account] = false;
    }

    // Añadir una dirección a la lista blanca para recibir tokens
    function addToWhiteList(address account) external onlyAuthorized {
        whiteList.push(account);
    }

    // Remover una dirección de la lista blanca
    function removeFromWhiteList(address accountToRemove) external onlyOwner {
        for (uint i = 0; i < whiteList.length; i++) {
            if (whiteList[i] == accountToRemove) {
                whiteList[i] = whiteList[whiteList.length - 1];
                whiteList.pop();
                break;
            }
        }
    }

    // Depositar tokens en el contrato
    function deposit(uint256 amount) external onlyAuthorized {
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        deposits[msg.sender] += amount;
        totalDeposited += amount;
    }

    // Iniciar el temporizador de liberación de tokens
    function startReleaseTimer() external onlyAuthorized {
        releaseTime = block.timestamp + WAIT_TIME;
    }

    // Distribuir tokens a las direcciones en la lista blanca
    function distributeTokens() external afterReleaseTime onlyAuthorized {
        require(totalDeposited > 0, "No tokens to distribute");
        uint256 amountPerAddress = totalDeposited / whiteList.length;
        for (uint i = 0; i < whiteList.length; i++) {
            token.transfer(whiteList[i], amountPerAddress);
        }
        totalDeposited = 0;
    }
}
