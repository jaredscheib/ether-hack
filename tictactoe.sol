pragma solidity ^0.4.0;

contract TicTacToe {

    enum GameStatus {
        needPlayersAndMinAnte,
        needAnteXO,
        needAnteX,
        needAnteO,
        xTurn,
        oTurn,
        xWon,
        oWon,
        draw
    }

    event EmitStatus(
        int gameStatus
    );

    enum ErrorCode {
        minAnteMustBeGreaterThan0,
        invalidSender,
        gameAlreadyInProgress,
        gameNotInProgress,
        notYourTurn
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
    bool isGameInProgress;

    GameStatus public gameStatus = GameStatus.needPlayersAndMinAnte;

    // modifier hasValidMinAnte () {
    //     if (minAnte <= 0) {
    //         return EmitError(ErrorCode.minAnteMustBeGreaterThan0);
    //     }
    //     if (isGameInProgress == true) {
    //         return EmitError(ErrorCode.gameAlreadyInProgress);
    //     }
    // }

    function createGame(address _x, address _o, uint256 _minAnte) public returns (bool) {
        // TODO: validate address _x & address_o ?
        if (isGameInProgress == true) {
            EmitError(int(ErrorCode.gameAlreadyInProgress));
            return false;
        }
        if (_minAnte <= 0) {
            EmitError(int(ErrorCode.minAnteMustBeGreaterThan0));
            return false;
        }

        x = _x;
        o = _o;
        minAnte = _minAnte;
        EmitStatus(int(gameStatus = GameStatus.needAnteXO));
        return true;
    }

    function anteUp() payable public returns (bool) {
        if (isGameInProgress == true) {
            EmitError(int(ErrorCode.gameAlreadyInProgress));
            return false;
        }

        if (msg.sender != x && msg.sender != o) {
            EmitError(int(ErrorCode.invalidSender));
            revert();
            return false;
        }
        if (msg.sender == x) {
            anteX += msg.value;
        }
        if (msg.sender == o) {
            anteO += msg.value;
        }
        if (anteX <= minAnte && anteO <= minAnte) {
            EmitStatus(int(gameStatus = GameStatus.needAnteXO));
            return true;
        }
        if (anteX > minAnte && anteO <= minAnte) {
            EmitStatus(int(gameStatus = GameStatus.needAnteO));
            return true;
        }
        if (anteX <= minAnte && anteO > minAnte) {
            EmitStatus(int(gameStatus = GameStatus.needAnteX));
            return true;
        }

        createBoard();
        currentPlayer = x;
        isGameInProgress = true;
        EmitStatus(int(gameStatus = GameStatus.xTurn));
        return true;
    }


    function makeMove(int position) private returns (GameStatus _status) {
        // place position and return result status
    }

    function playTurn(int position) public returns (bool) {
        if (isGameInProgress == false) {
            EmitError(int(ErrorCode.gameNotInProgress));
            return false;
        }

        if (msg.sender != currentPlayer) {
            EmitError(int(ErrorCode.notYourTurn));
            return false;
        }

        // play the move
        gameStatus = makeMove(position);
        EmitStatus(int(gameStatus));

        if (gameStatus == GameStatus.xWon) {
            this.transfer(x);
            return true;
        } else if (gameStatus == GameStatus.oWon) {
            this.transfer(o);
            return true;
        } else if (gameStatus == GameStatus.draw) {
            // TODO: refund money to players
            revert();
            return false;
        }

        // switch player
        if (gameStatus == GameStatus.xTurn) {
            currentPlayer = x;
        }
        if (gameStatus == GameStatus.oTurn) {
            currentPlayer = o;
        }
        return true;
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
