// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title Factory
 * @dev A contract that compute contract address before deploying
 */
contract Factory {
    event Deployed(address addr);

    /**
     * @dev Deploys a new instance of the TestContract contract with a given salt value.
     * @param _salt The salt value used for contract deployment.
     */
    function deploy(uint _salt) public {
        TestContract myContract = new TestContract{salt: bytes32(_salt)}(msg.sender);
        emit Deployed(address(myContract));
    }

    /**
     * @dev Returns the bytecode of the TestContract contract.
     * @param _owner The owner address to be encoded in the bytecode.
     * @return The concatenated bytecode with the encoded owner address.
     */
    function getBytecode(address _owner) public pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner));
    }

    /**
     * @dev Computes the deployment address for a contract instance using the given bytecode and salt value.
     * @param bytecode The bytecode of the contract.
     * @param _salt The salt value used for contract deployment.
     * @return The computed deployment address.
     */
    function getAddress(bytes memory bytecode, uint _salt) public view returns (address) {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode)));
        return address(uint160(uint(hash)));
    }
}

/**
 * @title TestContract
 * @dev A simple contract with an owner address.
 */
contract TestContract {
    address public owner;

    /**
     * @dev Constructor that sets the owner of the contract.
     * @param _owner The owner address.
     */
    constructor(address _owner) payable {
        owner = _owner;
    }
}
