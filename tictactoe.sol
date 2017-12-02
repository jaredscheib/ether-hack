// mur: specify pragma (solidity version)

contract TicTacToe {

    enum BoardState {
        x,
        o,
        empty
    }

    // mur: see how one can use enums:
    // http://solidity.readthedocs.io/en/develop/common-patterns.html#state-machine
    enum GameStatus {
        xWon, oWon, tie, next, invalid
    }

    enum BoardPosition {
        0,1,2,3,4,5,6,7,8
    }

    // mur: create error event for error logs

    BoardState[] board;
    address x;
    address o;

    function TicTacToe() public {
        // no need for intializer
    }

    uint256 minAnte;
    uint256 anteX;
    uint256 anteO;

    address currrentPlayer;

    function anteUp() payable public {
        if (msg.sender == x) {
            anteX += msg.value;
        }
        if (msg.sender == o) {
            anteO += msg.value;
        }

        // mur: handle case when someone else sends ether and it stucks here forever
    }

    function isGamePlayable() internal returns bool {
        require( anteX >= minAnte && anteO >= minAnte );  // mur: return bool instead of require
    }

    function createGame(address _x, address _o, uint256 _minAnte) public {
        x = _x;
        o = _o;
        currrentPlayer = _x;
        minAnte = _minAnte;
    }

    function makeMove(BoardPosition position) internal returns (GameStatus _status) {

    }

    function playTurn(BoardPosition position) public returns (GameStatus _status) { // mur: returns bool
        require ( this.isGamePlayable() );  // mur: emit error, return false

        if (msg.sender == currrentPlayer) {
            // play the move
            status = this.makeMove(position);

            if (status == GameStatus.xWon) {
                this.transfer(x)
            } else if (status == GameStatus.oWon) {
                this.transfer(o)
            } else if (status == GameStatus.tie) {
                // do we send status first?
                revert();  // mur: shouldn't we return money back to players?
            } else if (status == GameStatus.invalid) {
                return GameStatus.invalid
            }

        } else {
            return GameStatus.invalid  // mur: emit error, return false
        }

        // switch player
        if (msg.sender == x) {
            currrentPlayer = o;
        }
        if (msg.sender == o) {
            currrentPlayer = x;
        }
        return GameStatus.next // mur: semicolon, return true
    }

    function isGameOver() internal constant returns (GameStatus _status) {
        // determine if game is over
    }

    // mur: calling other contracts can be tricky, and transfer is actually
    // a call to other address's fallback function
    // (http://solidity.readthedocs.io/en/develop/contracts.html#fallback-function),
    // if it's a contract (and it can be true).
    // If user plays through a contract, and this contract in some way
    // reverts all of the incoming transfers (don't laugh, we had such case),
    // the game will never end. It's ok if the contract doesn't imply playing
    // several times, but it could ruin game reset if it is implemented,
    // and it can be much much worse in other scenarios. So what we want is
    // to allow people pull what they need themselves:
    // http://solidity.readthedocs.io/en/develop/common-patterns.html#withdrawal-from-contracts
    function transfer(address _winner) {
        _winner.transfer(anteO + anteX);
    }

}
