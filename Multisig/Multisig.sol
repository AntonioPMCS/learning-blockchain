// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/// @title A contract that allows multiple signers to execute transactions
/// @author Bruno Oliveira, Simão Arriaga, António Silva
/// @notice You define a number of signers to execute the tx inside a given proposal
/// @dev This contract does allows both code execution and ethers transfers
/// @custom:educational This is an educational contract.
contract Multisig {

    // The transaction is the part that is executed in a proposal
    struct Transaction {
        // who wil receive the ether
        address to;
        // how much he will receive
        uint amount;
        // Wether it was already executed or not. To avoid double spending
        bool executed;
        bytes callData;
    }

    // A proposal is defined as:
    // - One transaction (transfer of Ether)
    // - A number of votes
    struct Proposal {
        uint8 requiredSigners;
        address[] signers;
        Transaction transaction;
    }

    mapping(address => bool) public allowedSigners;
    uint public totalSigners = 0;

    modifier proposalExists(uint index) {
        // Verify proposals index
        require(index < proposals.length, "Invalid proposal index");
        _;
    }

    // The complete array list of existing proposals. 
    // They are created in crescent order. The first proposal is proposal 0,
    // ...the second is proposal 1, the third is proposal 2, and so on...
    Proposal[] public proposals;


    constructor (address[] memory signerList) payable {
        for (uint i = 0; i < signerList.length; i++) {
            // signerList[i] is an address.
            // Adds the address at signerList[i] to the allowedSigners mapping
            allowedSigners[signerList[i]] = true;
        }
        totalSigners = signerList.length;
    }


    // entender memory e calldata nos parametros

    /// @notice Adds a signature to a proposal
    /// @dev Pushes the signer address to the signers array in the proposal
    /// @param index References the proposal to be signed
    function sign(uint index) proposalExists(index) external {
        // Verify that signer address is in the whitelist mapping.
        require(allowedSigners[msg.sender], "Unauthorized signer");

        // Verificar que o address ainda nao assinou
        for (uint i = 0; i < proposals[index].signers.length; i++) {
            if (proposals[index].signers[i] == msg.sender) {
                revert("Proposal already signed by signer");
            } 
        }
        // Adicionar msg.sender ao "signers". Passou a verificação, assinou
        proposals[index].signers.push(msg.sender);
    }

    function createProposal(address to, uint amount, uint8 requiredSigners, bytes calldata callData) external {
        require(requiredSigners <= totalSigners, "Proposal requires more signers than exist");
        Transaction memory newTransaction = Transaction(to, amount, false, callData);
        Proposal memory newProposal = Proposal(requiredSigners, new address[](0), newTransaction);
        proposals.push(newProposal);
    }

    function getSigners(uint index) proposalExists(index) public view returns (address[] memory){
        return proposals[index].signers;
    }

    /// @notice Tries to execute the transaction inside a proposal
    /// @dev Uses address.transfer()
    /// @param index References the proposal to be signed
    function executeProposal(uint index) proposalExists(index) external {
        // Verify the proposal hasn't been executed yet
        require(proposals[index].transaction.executed == false, "Tx was executed before");
        // Verify the proposal has the required number of signatures
        require(proposals[index].signers.length >= proposals[index].requiredSigners, "Not enough signatures");

        address payable _to =  payable(proposals[index].transaction.to);
        uint _amount = proposals[index].transaction.amount;
        bytes memory _callData = proposals[index].transaction.callData;
        uint _dataLength = _callData.length;

        // Verify the contract has the necessary funds
        require(address(this).balance >= _amount, "Insufficient funds in the contract");
        // Transfer the ether
        if (_callData.length == 0) { _to.transfer(_amount); }
        else {
            bool result;
            assembly {
                let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
                let d := add(_callData, 32) // First 32 bytes are the padded length of data, so exclude that
                result := call(
                    gas(),                // Use gas() instead of sub(gas, 34710), as gas cost calculation changes dynamically
                    _to,
                    _amount,
                    d,
                    _dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
                    x,
                    0                  // Output is ignored, therefore the output size is zero
                )
            }  
        }
    }

    function receiveFunds() external payable{
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}