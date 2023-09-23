# 📜 02_DepositoERC20

## 📝 Descripción
El contrato `DepositoERC20` facilita la gestión segura de depósitos de tokens ERC20 por parte de cuentas específicamente autorizadas. Una vez que los tokens han sido depositados en el contrato, se mantienen en custodia durante un período predeterminado. Al final de este período, los tokens pueden ser distribuidos proporcionalmente entre una serie de direcciones enlistadas en la lista blanca.

## 🚀 Funcionalidades

- **Depósito de Tokens**: Las cuentas autorizadas pueden depositar tokens ERC20 en el contrato.
- **Distribución de Tokens**: Después de un período de espera de 4 semanas, los tokens depositados pueden ser distribuidos equitativamente entre las direcciones en la lista blanca.
- **Gestión de Lista Blanca**: Las cuentas autorizadas tienen la capacidad de agregar direcciones a la lista blanca, que son las direcciones elegibles para recibir la distribución de tokens.
- **Inicio de Temporizador**: Las cuentas autorizadas pueden iniciar el temporizador de liberación de tokens, que define el período de espera antes de que los tokens puedan ser distribuidos.
- **Autorización y Revocación**: Solo el propietario del contrato tiene la capacidad de autorizar o revocar el acceso de otras cuentas para depositar tokens.

## 🔐 Seguridad
El contrato ha sido diseñado con múltiples modificadores y controles para garantizar que solo las cuentas autorizadas puedan interactuar con las funciones esenciales, y para asegurar que la distribución de tokens solo pueda ocurrir después del período de espera adecuado.
