import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

class PlaySnakeGame extends StatefulWidget {
  const PlaySnakeGame({super.key});

  @override
  _PlaySnakeGameState createState() => _PlaySnakeGameState();
}

class _PlaySnakeGameState extends State<PlaySnakeGame> {
  int player1Position = 0;
  int player2Position = 0;
  int currentPlayer = 1; // 1 for Player 1 (Red), 2 for Player 2 (Green)
  bool gameOver = false;
  final List<int> ladders = [4, 9, 21, 28, 40, 51, 63, 71];
  final List<int> snakes = [16, 47, 49, 56, 62, 64, 87, 93, 95, 98];
  final picker = ImagePicker();

  // Roll dice function
  int rollDice() {
    Random random = Random();
    return 1 + random.nextInt(6); // Generates a random number between 1 and 6
  }

  // Move player and handle ladders and snakes
  void movePlayer(int roll) {
    setState(() {
      if (currentPlayer == 1) {
        player1Position += roll;
        if (ladders.contains(player1Position)) {
          // Player 1 lands on ladder
          _showCameraAndMessage('ladder');
        } else if (snakes.contains(player1Position)) {
          // Player 1 lands on snake
          _showCameraAndMessage('snake');
        }
        if (player1Position >= 100) {
          // Player 1 wins
          gameOver = true;
        }
        currentPlayer = 2; // Next player's turn
      } else {
        player2Position += roll;
        if (ladders.contains(player2Position)) {
          // Player 2 lands on ladder
          _showCameraAndMessage('ladder');
        } else if (snakes.contains(player2Position)) {
          // Player 2 lands on snake
          _showCameraAndMessage('snake');
        }
        if (player2Position >= 100) {
          // Player 2 wins
          gameOver = true;
        }
        currentPlayer = 1; // Next player's turn
      }
    });
  }

  // Function to open camera and display the corresponding message
  void _showCameraAndMessage(String type) async {
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      String message = '';
      if (type == 'ladder') {
        message =
            'Good job! To prevent Dengue, ensure to clean stagnant water and cover water storage.';
      } else if (type == 'snake') {
        message =
            'Oops! To prevent Dengue, avoid leaving garbage in open areas and letting water accumulate.';
      }

      _showDialog(message);
    }
  }

  // Show popup with message
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Action Completed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Continue the game after the dialog is closed
                setState(() {});
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Start a new game
  void startNewGame() {
    setState(() {
      player1Position = 0;
      player2Position = 0;
      currentPlayer = 1;
      gameOver = false;
    });
  }

  // Create a grid of 100 tiles with ladder and snake visuals
  Widget buildBoard() {
    List<Widget> tiles = [];
    for (int i = 0; i < 100; i++) {
      bool isPlayer1 = i == player1Position;
      bool isPlayer2 = i == player2Position;
      bool isLadder = ladders.contains(i);
      bool isSnake = snakes.contains(i);

      tiles.add(
        Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isLadder
                ? Colors.blue
                : isSnake
                    ? Colors.red
                    : Colors.white,
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isPlayer1)
                Positioned(
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                  ),
                ),
              if (isPlayer2)
                Positioned(
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.green,
                  ),
                ),
              if (isLadder)
                Positioned(
                  child: Icon(Icons.arrow_upward, color: Colors.white),
                ),
              if (isSnake)
                Positioned(
                  child: Icon(Icons.arrow_downward, color: Colors.white),
                ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        childAspectRatio: 1,
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        return tiles[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Play Snake-Ladder Game"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: startNewGame,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!gameOver)
              Column(
                children: [
                  Text('Player 1 (Red) Position: $player1Position'),
                  Text('Player 2 (Green) Position: $player2Position'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (!gameOver) {
                        int roll = rollDice();
                        movePlayer(roll);
                      }
                    },
                    child: Text('Roll Dice'),
                  ),
                  SizedBox(height: 20),
                  Text(
                      'Current Player: ${currentPlayer == 1 ? "Player 1 (Red)" : "Player 2 (Green)"}'),
                  SizedBox(height: 20),
                  Container(
                    height: 300,
                    width: 300,
                    child: buildBoard(), // Displaying the board
                  ),
                ],
              ),
            if (gameOver)
              Column(
                children: [
                  Text(player1Position >= 100
                      ? 'Player 1 (Red) Wins!'
                      : 'Player 2 (Green) Wins!'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: startNewGame,
                    child: Text('Start New Game'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
