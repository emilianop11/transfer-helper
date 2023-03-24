# Transfer helper

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
npx hardhat run scripts/deploy.js --network matic
```

deployment gas 1,121,337 aprox 0.1828 matic

new version feb 6 2023 0xc7F96d7244c11E34F5Ad7Fc527114fdE1812cc1A

This contract must always have enough matic balance


This contract is used by Fiume to transfer tokens from two different users without having them pay the gas fees. The sender should whitelist this contract before sending the transaction. In the backend of fiume, the owner of this contracts calls its "transfer from" function, allow funds to be moved from the sender to the receipient. The contract owner pays the gass fees and receives a compensation in usdc.

This feature is enabled through 3 different functions.

Transfer From: simply sends usdc from sender to recipient and the contract owner pays gas fee

Transfer From with Fee: sends usdc from sender to recepient, owner pays gas fee and receives an amount of USDC from sender as well. this amount is determined by the _feeBase in the parameters

transferFromWithReferrer: the gas fee is paid by the owner but the amount of USDC the owner receives as the platform fee is split 50/50 between the owner and a referrer account

swapForMatic: is a function that can only be called by the contract owner and allows the contract to transfer matic to the sender. (notice that this matic balance is the matic balance of the contract itself). In this same operation, usdc is sent to the owner of the contract, as compensation for the sent matic.