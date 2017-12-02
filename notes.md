### Smart Contracts
- maintains a data store
- as an externally owned account with a more complicated access policy
- manage an ongoing contract or relationship between multiple users
- provider functions to other contracts

### Gas
- every single operation that is executed inside the EVM is actually simultaneously executed by every full node
- in order to prevent deliberate attacks and abuse, the Ethereum protocol charges a fee per computational step

# Solidity

## Tools
- Truffle: https://truffleframework.com
  - tests for contracts in Solidity or JavaScript
  - will need to run Truffle's RPC client, where our code will be deployed
    and kind of simulates the Ethereum blockchain
    - formerly at https://github.com/ethereumjs/testrpc - now folded into Truffle
- OpenZeppelin: https://openzeppelin.com
  - see what other developers are up to
- Web3.js: https://github.com/ethereum/web3.js
- Remix:
  - browser-based IDE that has a Solidity linter & can simulate EVM for testing
  - this allows you to hand-check everything
- Dapp
  - honorable mention - he's never used it, but he's heard good things
- Mist - full-node client
- there are also tools that help evaluate your contract for cost

  ## Workflow
  - Code (Editor) --> Deploy (Truffle + TestRPC) --> Test (Remix) --> Deploy (Mist) --> Fun & Profit
    - Fail at every step

## Sample Code
```
pragma solidity ^0.4.0;

contract SimpleStorage {
  uint storedData;

  function set(uint x) {
    storedData = x;
  }

  function get() constant returns (uint) {
    return
  }
}
```
- pragma
  -
- storedData is a state variable because it requires some gas to write it to the blockchain
- setters & getters
  - set()
    - write to the blockchain via assignments
    - no return statement
  - get()


## Variables & Types
- function scoped (global / local variables)
- uint (unsigned)
- address (20 byte)
  - your personal address or contract address, typically hex
  - any address to a variable will use this type
- enums, structs
- arrays
  - notation is reversed in n-dimensional or dynamic arrays
  - as an example, an array of
- bytes, strings
- constant -constant state variables

## Function Structure
- function (<parameter types>)
- internal (default) - can only be called inside the current contract
- external - can be passed via and returned from external function calls
- contract functions themselves are `public` by default
- function types
  - pure -guaranteed not to read from or modify the state
  - view - guaranteed to not modify the state
  - constants - alias to view
    - functions that have `constant` typically read data, therefore the functions require a `return`
    - functions without `constant` typically write data therefore the function doesn't need a `return`
- mappings
  - syntax: mapping( <KeyType> => <ValueType> ) <variable>
  - you can iterate over these, but you don't want to
- structs
- special variables & functions
  - msg.value: amount of WEI being sent
  - msg.sender: address of agent sending message (initalizer)
  - <address>.balance
  - <address>.transfer(<amount>);
  - selfdestruct(address recipient)
    - call this on your contract, and name the recipient of your contract's value
- the most special of functions
  - function () payable {}
  - a function has no name
  - default function for contract (Fall back) - if it has no other function, this will be invoke
  - (?)
- modifiers
  - modify (wrap) a function -- used as access control for contract
  - e.g.:
    function withdrawAllTheMoney() public onlyOwner {
      msg.send(balance); // pr0tect me plz
    }
    modifier onlyOwner {
      if(msg.sender != owner) {
        revert();
      }
      _ ; // where function is actually injected
    }
- events
  - syntax: event Name (<types>)
  - used as debug/logging/event watching
- pro-tips
  - explicitly declare types
  - explicitly convert types
  - watch out for integer overflows, underflows (uint256 == 2**256)
    - don't use this in your own, but could be used malevolently against others
  - all denominations in WEI (1ETH = 10E-18 WEI)
  - returning strings from functions
    - you can't transfer strings between contracts (?)
    - see quote
  - every operation has a cost, and every contract has a gas limit
    - so you have to be careful about how much operations you perform
    - and you may have to split your contract into multiple contracts
    - there are tools that can help evaluate your contract for cost

## Deployment
?

## How to money?
- EthLance! https://ethlance.com/ - many scammers out there

## Help
- Good (slow):
  - solidity.readthedocs.io
  - reddit.com/r/ethdev
- Good (fast):
  - gitter.im/ConsenSys/smart-contract-best-practices
  - gitter.im/ConsenSys/truffle
  - (?)
- Not as good (?)

## More help
- come to NoiseBridge for Hack Days every week
  - 18th / Mission
  - local non-profit hackerspace
  - Python classes, Arduino classes
  - open to public: 10am-9pm
  - 3d printers
  - noisebridge.net
- Twitter: @dpg
- Github: dpgailey
- Facebook: Dan Gailey
- Email: dan at synapse ai
- Synapse.ai
  - Decentralized Data + AI
  - hello@synapse.ai
  - synapse.ai/marketplace

## Resources
- Ethereum Dev Tutorial: github.com/ethereum/wiki/wiki/Ethereum-Development-Tutorial
- Cost of a real world contract: hackernoon.com/costs-of-a-real-world-ethereum-contract-2033511b3214
- ethgasstation.info
- ethstats.net
- etherhack.slack.com

## What's next?
- build dapps
- decentralize everything
- disrupt existing monopolies
- profit
