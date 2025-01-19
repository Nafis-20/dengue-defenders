import 'package:flutter/material.dart';
import 'dart:math';

class SnakeLadderGame extends StatefulWidget {
  const SnakeLadderGame({super.key});

  @override
  _SnakeLadderGameState createState() => _SnakeLadderGameState();
}

class _SnakeLadderGameState extends State<SnakeLadderGame> {
  int player1Position = 1;
  int player2Position = 1;
  int currentPlayer = 1;
  int diceRoll = 0;
  bool gameOver = false;

  final Map<int, int> snakes = {
    16: 6,
    47: 26,
    49: 11,
    56: 53,
    62: 19,
    64: 60,
    87: 24,
    93: 73,
    95: 75,
    98: 78,
  };

  final Map<int, int> ladders = {
    4: 14,
    9: 31,
    21: 42,
    28: 84,
    40: 59,
    51: 67,
    63: 81,
    71: 91,
  };

  double tileSize = 40.0;

  Offset getTilePosition(int position) {
    int row = (position - 1) ~/ 10;
    int col = (position - 1) % 10;

    if (row % 2 == 0) {
      col = 9 - col; // Reverse direction for even rows
    }

    row = 9 - row; // Flip rows (bottom to top)

    return Offset(col * tileSize + tileSize / 2, row * tileSize + tileSize / 2);
  }

  void rollDice() async {
    if (gameOver) return;

    setState(() {
      diceRoll = Random().nextInt(6) + 1;
    });

    await movePlayer(diceRoll);

    if (player1Position == 100 || player2Position == 100) {
      setState(() {
        gameOver = true;
      });
      showWinDialog(currentPlayer == 1 ? "Player 1" : "Player 2");
    } else {
      setState(() {
        currentPlayer = currentPlayer == 1 ? 2 : 1;
      });
    }
  }

  Future<void> movePlayer(int steps) async {
    for (int i = 0; i < steps; i++) {
      await Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          if (currentPlayer == 1) {
            player1Position++;
            if (player1Position > 100) player1Position = 100;
          } else {
            player2Position++;
            if (player2Position > 100) player2Position = 100;
          }
        });
      });
    }
    handlePosition(
        currentPlayer == 1 ? player1Position : player2Position, currentPlayer);
  }

  void handlePosition(int position, int player) {
    if (snakes.containsKey(position)) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          if (player == 1) {
            player1Position = snakes[position]!;
          } else {
            player2Position = snakes[position]!;
          }
        });
      });
    } else if (ladders.containsKey(position)) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          if (player == 1) {
            player1Position = ladders[position]!;
          } else {
            player2Position = ladders[position]!;
          }
        });
      });
    }
  }

  void resetGame() {
    setState(() {
      player1Position = 1;
      player2Position = 1;
      currentPlayer = 1;
      diceRoll = 0;
      gameOver = false;
    });
  }

  void showWinDialog(String winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("🎉 Congratulations! $winner Wins! 🎉"),
          content: const Text(
              "Would you like to play again or return to the homepage?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text("Rematch"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Navigate back to homepage
              },
              child: const Text("Homepage"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake and Ladder'),
        actions: [
          IconButton(
            onPressed: resetGame,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Board Background with Snakes and Ladders
          Positioned.fill(
            child: CustomPaint(
              painter: BoardPainter(
                  snakes: snakes, ladders: ladders, tileSize: tileSize),
            ),
          ),
          // Player Positions
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: getTilePosition(player1Position).dx - 15,
            top: getTilePosition(player1Position).dy - 15,
            child: const PlayerAvatar(color: Colors.blue),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: getTilePosition(player2Position).dx - 15,
            top: getTilePosition(player2Position).dy - 15,
            child: const PlayerAvatar(color: Colors.yellow),
          ),
          // Controls and Info
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Dice Roll: $diceRoll',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: gameOver ? null : rollDice,
                    child: const Text('Roll Dice'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BoardPainter extends CustomPainter {
  final Map<int, int> snakes;
  final Map<int, int> ladders;
  final double tileSize;

  BoardPainter(
      {required this.snakes, required this.ladders, required this.tileSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw Board Tiles
    for (int row = 0; row < 10; row++) {
      for (int col = 0; col < 10; col++) {
        final isEvenTile = (row + col) % 2 == 0;
        paint.color = isEvenTile ? Colors.teal.shade200 : Colors.teal.shade300;
        canvas.drawRect(
          Rect.fromLTWH(col * tileSize, row * tileSize, tileSize, tileSize),
          paint,
        );

        // Draw Tile Numbers
        final tileNumber = (9 - row) * 10 + (row % 2 == 0 ? col + 1 : 10 - col);
        final textPainter = TextPainter(
          text: TextSpan(
            text: tileNumber.toString(),
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          Offset(
            col * tileSize + tileSize / 4,
            row * tileSize + tileSize / 4,
          ),
        );
      }
    }

    // Draw Ladders
    paint.color = Colors.brown;
    paint.strokeWidth = 6.0;
    for (var entry in ladders.entries) {
      final start = getTilePosition(entry.key);
      final end = getTilePosition(entry.value);
      canvas.drawLine(start, end, paint);
    }

    // Draw Snakes
    final snakePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    for (var entry in snakes.entries) {
      final start = getTilePosition(entry.key);
      final end = getTilePosition(entry.value);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2 - 20,
          end.dx,
          end.dy,
        );

      canvas.drawPath(path, snakePaint);
    }
  }

  Offset getTilePosition(int position) {
    int row = (position - 1) ~/ 10;
    int col = (position - 1) % 10;

    if (row % 2 == 0) {
      col = 9 - col;
    }
    row = 9 - row;

    return Offset(col * tileSize + tileSize / 2, row * tileSize + tileSize / 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PlayerAvatar extends StatelessWidget {
  final Color color;

  const PlayerAvatar({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
    );
  }
}

//   void drawSnake(Canvas canvas, Offset start, Offset end) {
//     final path = Path()
//       ..moveTo(start.dx, start.dy)
//       ..quadraticBezierTo(
//         (start.dx + end.dx) / 2,
//         (start.dy + end.dy) / 2 - 30,
//         end.dx,
//         end.dy,
//       );

//     final snakePaint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 6.0;

//     canvas.drawPath(path, snakePaint);

//     // Draw head and tail markers
//     canvas.drawCircle(start, 8.0, snakePaint..style = PaintingStyle.fill);
//     canvas.drawCircle(end, 5.0, snakePaint);
//   }

//   Offset getTilePosition(int position) {
//     int row = (position - 1) ~/ 10;
//     int col = (position - 1) % 10;

//     if (row % 2 == 0) {
//       col = 9 - col;
//     }
//     row = 9 - row;

//     return Offset(col * tileSize + tileSize / 2, row * tileSize + tileSize / 2);
//   }
