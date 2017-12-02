pragma solidity ^0.4.0;

contract TicTacToe {

    enum GameStatus {
        needPlayersAndMinAnte,
        needAnteXO,
        needAnteX,
        needAnteO,
        xTurn,
        yTurn,
        xWon,
        oWon,
        draw
    }

    event EmitStatus(
        int gameStatus
    );

    enum ErrorCode {
        minAnteMustBeGreaterThan0,
        invalidSender
    }

    event EmitError(
        int ErrorCode
    );

    enum BoardPosition {
        empty,
        x,
        o
    }

    function createBoard() private {
        BoardPosition[] memory board = new BoardPosition[](9);
    }

    address x;
    address o;

    uint256 minAnte;
    uint256 anteX;
    uint256 anteO;

    address currentPlayer;

    GameStatus public gameStatus = GameStatus.needPlayersAndMinAnte;

    function createGame(address _x, address _o, uint256 _minAnte) public {
        if (_minAnte <= 0) {
            EmitError(ErrorCode.minAnteMustBeGreaterThan0);
            return;
        }

        x = _x;
        o = _o;
        minAnte = _minAnte;
        EmitStatus(gameStatus = GameStatus.needAnteXO);
    }

    function anteUp() payable public {
        if (msg.sender != x && msg.sender != o) {
            EmitError(ErrorCode.InvalidSender);
            revert();
        }
        if (msg.sender == x) {
            anteX += msg.value;
        }
        if (msg.sender == o) {
            anteO += msg.value;
        }
        if (anteX > 0) {
            if (anteO > 0) {
                EmitStatus(gameStatus = GameStatus.antedUp);
                return;
            } else {
                EmitStatus(gameStatus = GameStatus.needAnteO);
                return;
            }
        } else {
            if (anteO > 0) {
                EmitStatus(gameStatus = GameStatus.needAnteX);
                return
            }
        }

        createBoard()
        currentPlayer = _x;
        EmitStatus(gameStatus = GameStatus.xTurn);
    }

    function makeMove(BoardPosition position) internal returns (GameStatus _status) {

    }

    function playTurn(BoardPosition position) public returns bool {
        if (anteX >= minAnte && anteO >= minAnte) {

        }

        if (msg.sender == currentPlayer) {
            // play the move
            status = this.makeMove(position);

            if (status == GameStatus.xWon) {
                this.transfer(x)
            } else if (status == GameStatus.oWon) {
                this.transfer(o)
            } else if (status == GameStatus.draw) {
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
            currentPlayer = o;
        }
        if (msg.sender == o) {
            currentPlayer = x;
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
