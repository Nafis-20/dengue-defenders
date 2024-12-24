import 'package:flutter/material.dart';
import 'dart:math';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> board = List.filled(9, "");
  bool isPlayerOneTurn = true;
  String message = "Player 1's Turn";

  final List<Map<String, dynamic>> questions = [
    {
      'question': "Where do Aedes mosquitoes usually breed?",
      'options': [
        "Flowing rivers",
        "In stagnant water",
        "On trees",
        "Inside animals"
      ],
      'answer': 1,
    },
    // Add more questions as needed
  ];

  void handleTileTap(int index) {
    if (board[index] == "") {
      _askQuestion(index);
    }
  }

  void _askQuestion(int index) {
    final question = questions[Random().nextInt(questions.length)];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple.shade50,
          title: Text(
            question['question'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: question['options'].asMap().entries.map<Widget>((entry) {
              final idx = entry.key;
              final option = entry.value;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _checkAnswer(index, idx == question['answer'], question);
                },
                child: Text(option),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _checkAnswer(int index, bool isCorrect, Map<String, dynamic> question) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isCorrect ? Colors.green.shade50 : Colors.red.shade50,
          title: Text(
            isCorrect ? "Correct!" : "Wrong!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isCorrect ? Colors.green : Colors.red,
            ),
          ),
          content: Text(
            isCorrect
                ? "You can make your move."
                : "The correct answer is: ${question['options'][question['answer']]}",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isCorrect) {
                  setState(() {
                    board[index] = isPlayerOneTurn ? "X" : "O";
                    isPlayerOneTurn = !isPlayerOneTurn;
                    message =
                        isPlayerOneTurn ? "Player 1's Turn" : "Player 2's Turn";
                  });
                  _checkWinner();
                } else {
                  setState(() {
                    isPlayerOneTurn = !isPlayerOneTurn;
                    message =
                        isPlayerOneTurn ? "Player 1's Turn" : "Player 2's Turn";
                  });
                }
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  void _checkWinner() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] != "" &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        _showGameOverDialog("${board[pattern[0]]} Wins!");
        return;
      }
    }

    if (board.every((tile) => tile != "")) {
      _showGameOverDialog("It's a Draw!");
    }
  }

  void _showGameOverDialog(String result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: Text(
            "Game Over",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: Text(
            result,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  board = List.filled(9, "");
                  isPlayerOneTurn = true;
                  message = "Player 1's Turn";
                });
              },
              child: Text("Restart"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dengue Tic Tac Toe"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => handleTileTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      border: Border.all(color: Colors.teal, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
