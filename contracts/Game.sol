pragma solidity ^0.5.0;

contract Game {
    uint256 private goal;
    uint256 private current;
    uint256 private total_score = 0;
    uint256 current_prize = 0;

    bool started = false;
    string message = "Press start";

    // Concat four strings
    function append(
        string memory a,
        string memory b,
        string memory c,
        string memory d
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d));
    }

    // Concat three strings
    function append(
        string memory a,
        string memory b,
        string memory c
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }

    function deposit() public payable {}

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }

    function start() public {
        goal =
            (uint256(
                keccak256(abi.encodePacked(block.timestamp, block.difficulty))
            ) % 30) +
            11;
        current =
            uint256(
                keccak256(abi.encodePacked(block.timestamp, block.difficulty))
            ) %
            10;

        message = append(uint2str(current), " => ", uint2str(goal));
        started = true;
        current_prize = 100;
    }

    function addTwo() public {
        if (!started) {
            message = "Please, start the game first";
        } else {
            current = current + 2;

            if (current_prize < 15) {
                current_prize = 0;
            } else {
                current_prize = current_prize - 15;
            }

            if (current == goal) {
                total_score = total_score + current_prize;
                started = false;
                message = "Congrats, you won! Press start to play again";
            } else if (current > goal) {
                message = "You lost!";
                started = false;
            } else {
                message = append(uint2str(current), " => ", uint2str(goal));
            }
        }
    }

    function addThree() public {
        if (!started) {
            message = "Please, start the game first";
        } else {
            current = current + 3;

            if (current_prize < 5) {
                current_prize = 0;
            } else {
                current_prize = current_prize - 5;
            }

            if (current == goal) {
                started = false;
                total_score = total_score + current_prize;
                message = "Congrats, you won! Press start to play again";
            } else if (current > goal) {
                message = "You lost!";
                started = false;
            } else {
                message = append(uint2str(current), " => ", uint2str(goal));
            }
        }
    }

    function showMessage() public view returns (string memory) {
        return message;
    }

    function currentPrize() public view returns (string memory) {
        return uint2str(current_prize);
    }

    function totalScore() public view returns (string memory) {
        return uint2str(total_score);
    }
}
