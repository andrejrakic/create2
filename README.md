## CREATE2

Boilerplate repo for deploying smart contracts with precompiled addresses using CREATE2 opcode. Includes script to compute as much addresses as possible in order to find :sparkles: the special one :sparkles:

### EIP-1014

This opcode was introduced in [EIP-1014](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1014.md)

### CREATE

Contract's address is computed as a keccak256 of the sender’s own address and a nonce

`contractAddress = keccak256(sender, nonce)`

or in Solidity,

```solidity
pair = new UniswapV2Pair()
```

### CREATE2

Contract's address is computed as a keccak256 of: `0xFF`, a constant that prevents collisions with CREATE, the sender’s own address, a salt (an arbitrary value provided by the sender), the to-be-deployed contract’s bytecode

`contractAddress = keccak256(0xFF, sender, salt, bytecode)`

or in Solidity,

```solidity
    bytes memory bytecode = type(UniswapV2Pair).creationCode;
    bytes32 salt = keccak256(abi.encodePacked(token0, token1));
    assembly {
        pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
    }
```
