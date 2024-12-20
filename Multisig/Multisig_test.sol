// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../Multisig.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    Multisig multisig;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // <instantiate contract>
        address[] memory accounts = new address[](1);
        accounts[0] = TestsAccounts.getAccount(1);
        multisig = new Multisig(accounts);
    }

    function checkDeploymentSuccess() public {
        Assert.ok(multisig.allowedSigners(TestsAccounts.getAccount(1)) == true, 'AllowedSigner should be true');
    }

    function checkDeploymentUnsucess() public {
        Assert.ok(multisig.allowedSigners(TestsAccounts.getAccount(2)) == false, "AllowedSigner should be false");
    }

    function createTransferEtherProposal() public {
        uint amount = 10 ether;

        multisig.createProposal(TestsAccounts.getAccount(2), //to
                                amount,
                                1, //required signer 
                                "" // no calldata)
        );
        
        Assert.ok(multisig.getProposalsCount() == 1, "Proposal was not added to proposals arrays");
        Assert.equal(multisig.getProposalTo(0),TestsAccounts.getAccount(2), "Unexpected proposal destination");
        Assert.equal(multisig.getProposalAmount(0), amount, "Unexpected amount");
        Assert.ok(multisig.getProposalData(0).length == 0, "Expecting no callData");
        Assert.equal(multisig.getProposalExecuted(0), false, "Expecting executed to be false");
        Assert.equal(multisig.getProposalSignersCount(0), 0, "Expecting signers to start empty");
    }

    function checkSuccess() public {
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.ok(2 == 2, 'should be true');
        Assert.greaterThan(uint(2), uint(1), "2 should be greater than to 1");
        Assert.lesserThan(uint(2), uint(3), "2 should be lesser than to 3");
    }

    function checkSuccess2() public pure returns (bool) {
        // Use the return value (true or false) to test the contract
        return true;
    }
    
    function checkFailure() public {
        Assert.notEqual(uint(1), uint(1), "1 should not be equal to 1");
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-1
    /// #value: 100
    function checkSenderAndValue() public payable {
        // account index varies 0-9, value is in wei
        Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
        Assert.equal(msg.value, 100, "Invalid value");
    }
}
    