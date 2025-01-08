import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart'; // For camera functionality

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

  void rollDice() async {
    if (gameOver) return;

    setState(() {
      diceRoll = Random().nextInt(6) + 1;
      if (currentPlayer == 1) {
        player1Position += diceRoll;
        if (player1Position > 100) {
          player1Position = 100 - (player1Position - 100);
        }
        handlePosition(player1Position, 1);
      } else {
        player2Position += diceRoll;
        if (player2Position > 100) {
          player2Position = 100 - (player2Position - 100);
        }
        handlePosition(player2Position, 2);
      }
    });

    if (player1Position == 100 || player2Position == 100) {
      setState(() {
        gameOver = true;
      });
    } else {
      setState(() {
        currentPlayer = currentPlayer == 1 ? 2 : 1;
      });
    }
  }

  Future<void> handlePosition(int position, int player) async {
    if (snakes.containsKey(position)) {
      await showSnakeOrLadderDialog(false, player);
      setState(() {
        if (player == 1) {
          player1Position = snakes[position]!;
        } else {
          player2Position = snakes[position]!;
        }
      });
    } else if (ladders.containsKey(position)) {
      await showSnakeOrLadderDialog(true, player);
      setState(() {
        if (player == 1) {
          player1Position = ladders[position]!;
        } else {
          player2Position = ladders[position]!;
        }
      });
    }
  }

  Future<void> showSnakeOrLadderDialog(bool isLadder, int player) async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.camera);

    String title = isLadder ? "Ladder!" : "Snake!";
    String message = isLadder
        ? "Great job! Remember to clean stagnant water and cover water storage."
        : "Oh no! Avoid leaving garbage in open areas and allowing water to accumulate.";

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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

  Widget buildTile(int number) {
    bool isPlayer1 = (number == player1Position);
    bool isPlayer2 = (number == player2Position);
    bool isSnake = snakes.containsKey(number);
    bool isLadder = ladders.containsKey(number);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: isPlayer1
            ? Colors.blue
            : isPlayer2
                ? Colors.yellow
                : isSnake
                    ? Colors.red.shade400
                    : isLadder
                        ? Colors.green.shade400
                        : Colors.white,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '$number',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (isPlayer1)
            Positioned(
              bottom: 4,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.blue,
              ),
            ),
          if (isPlayer2)
            Positioned(
              top: 4,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.yellow,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildBoard() {
    List<Widget> tiles = [];
    bool leftToRight = true;

    for (int row = 0; row < 10; row++) {
      List<int> rowNumbers =
          List.generate(10, (index) => (row * 10 + index + 1));
      if (!leftToRight) rowNumbers = rowNumbers.reversed.toList();

      tiles.addAll(rowNumbers.map((number) => buildTile(number)));

      leftToRight = !leftToRight;
    }

    return GridView.builder(
      reverse: true, // Ensures 1 is at the bottom
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        return tiles[index];
      },
    );
  }

  Widget buildInfoRow(Map<int, int> mapping, String title) {
    List<String> entries =
        mapping.entries.map((e) => "${e.key} → ${e.value}").toList();

    String firstLine = entries.sublist(0, entries.length ~/ 2).join(', ');
    String secondLine = entries.sublist(entries.length ~/ 2).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(firstLine),
        Text(secondLine),
      ],
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildBoard(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Player 1 Position: $player1Position',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Player 2 Position: $player2Position',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dice Roll: $diceRoll',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                buildInfoRow(ladders, "Ladders (Start → End):"),
                const SizedBox(height: 8),
                buildInfoRow(snakes, "Snakes (Start → End):"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: gameOver ? null : rollDice,
                  child: const Text('Roll Dice'),
                ),
                if (gameOver)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Game Over! Player ${player1Position == 100 ? 1 : 2} Wins!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'dart:math';
// import 'package:vector_math/vector_math_64.dart' as vector;

// class SnakeLadderGame extends StatefulWidget {
//   const SnakeLadderGame({super.key});

//   @override
//   _SnakeLadderGameState createState() => _SnakeLadderGameState();
// }

// class _SnakeLadderGameState extends State<SnakeLadderGame> {
//   int player1Position = 1;
//   int player2Position = 1;
//   int currentPlayer = 1;
//   int diceRoll = 0;
//   bool gameOver = false;

//   final Map<int, int> snakes = {
//     16: 6,
//     47: 26,
//     49: 11,
//     56: 53,
//     62: 19,
//     64: 60,
//     87: 24,
//     93: 73,
//     95: 75,
//     98: 78,
//   };

//   final Map<int, int> ladders = {
//     4: 14,
//     9: 31,
//     21: 42,
//     28: 84,
//     40: 59,
//     51: 67,
//     63: 81,
//     71: 91,
//   };

//   void rollDice() async {
//     if (gameOver) return;

//     setState(() {
//       diceRoll = Random().nextInt(6) + 1;
//       if (currentPlayer == 1) {
//         player1Position += diceRoll;
//         if (player1Position > 100) {
//           player1Position = 100 - (player1Position - 100);
//         }
//         handlePosition(player1Position, 1);
//       } else {
//         player2Position += diceRoll;
//         if (player2Position > 100) {
//           player2Position = 100 - (player2Position - 100);
//         }
//         handlePosition(player2Position, 2);
//       }
//     });

//     if (player1Position == 100 || player2Position == 100) {
//       setState(() {
//         gameOver = true;
//       });
//     } else {
//       setState(() {
//         currentPlayer = currentPlayer == 1 ? 2 : 1;
//       });
//     }
//   }

//   Future<void> handlePosition(int position, int player) async {
//     if (snakes.containsKey(position)) {
//       await showARView("Oh no! Avoid leaving garbage in open areas.");
//       setState(() {
//         if (player == 1) {
//           player1Position = snakes[position]!;
//         } else {
//           player2Position = snakes[position]!;
//         }
//       });
//     } else if (ladders.containsKey(position)) {
//       await showARView("Great job! Remember to clean stagnant water.");
//       setState(() {
//         if (player == 1) {
//           player1Position = ladders[position]!;
//         } else {
//           player2Position = ladders[position]!;
//         }
//       });
//     }
//   }

//   Future<void> showARView(String message) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ARScreen(message: message),
//       ),
//     );
//   }

//   void resetGame() {
//     setState(() {
//       player1Position = 1;
//       player2Position = 1;
//       currentPlayer = 1;
//       diceRoll = 0;
//       gameOver = false;
//     });
//   }

//   Widget buildTile(int number) {
//     bool isPlayer1 = (number == player1Position);
//     bool isPlayer2 = (number == player2Position);
//     bool isSnake = snakes.containsKey(number);
//     bool isLadder = ladders.containsKey(number);

//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black),
//         color: isPlayer1
//             ? Colors.blue
//             : isPlayer2
//                 ? Colors.yellow
//                 : isSnake
//                     ? Colors.red.shade400
//                     : isLadder
//                         ? Colors.green.shade400
//                         : Colors.white,
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Text(
//             '$number',
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           if (isPlayer1)
//             Positioned(
//               bottom: 4,
//               child: CircleAvatar(
//                 radius: 8,
//                 backgroundColor: Colors.blue,
//               ),
//             ),
//           if (isPlayer2)
//             Positioned(
//               top: 4,
//               child: CircleAvatar(
//                 radius: 8,
//                 backgroundColor: Colors.yellow,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget buildBoard() {
//     List<Widget> tiles = [];
//     bool leftToRight = true;

//     for (int row = 0; row < 10; row++) {
//       List<int> rowNumbers =
//           List.generate(10, (index) => (row * 10 + index + 1));
//       if (!leftToRight) rowNumbers = rowNumbers.reversed.toList();

//       tiles.addAll(rowNumbers.map((number) => buildTile(number)));

//       leftToRight = !leftToRight;
//     }

//     return GridView.builder(
//       reverse: true, // Ensures 1 is at the bottom
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 10,
//       ),
//       itemCount: 100,
//       itemBuilder: (context, index) {
//         return tiles[index];
//       },
//     );
//   }

//   Widget buildInfoRow(Map<int, int> mapping, String title) {
//     List<String> entries =
//         mapping.entries.map((e) => "${e.key} → ${e.value}").toList();

//     String firstLine = entries.sublist(0, entries.length ~/ 2).join(', ');
//     String secondLine = entries.sublist(entries.length ~/ 2).join(', ');

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         Text(firstLine),
//         Text(secondLine),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Snake and Ladder'),
//         actions: [
//           IconButton(
//             onPressed: resetGame,
//             icon: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: buildBoard(),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Text(
//                   'Player 1 Position: $player1Position',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Player 2 Position: $player2Position',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Dice Roll: $diceRoll',
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 buildInfoRow(ladders, "Ladders (Start → End):"),
//                 const SizedBox(height: 8),
//                 buildInfoRow(snakes, "Snakes (Start → End):"),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: gameOver ? null : rollDice,
//                   child: const Text('Roll Dice'),
//                 ),
//                 if (gameOver)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Game Over! Player ${player1Position == 100 ? 1 : 2} Wins!',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ARScreen extends StatelessWidget {
//   final String message;

//   const ARScreen({required this.message, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("AR View")),
//       body: ArCoreView(
//         onArCoreViewCreated: _onArCoreViewCreated,
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.close),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }

//   void _onArCoreViewCreated(ArCoreController controller) {
//     controller.addArCoreNode(
//       ArCoreNode(
//         shape: ArCoreSphere(
//           materials: [ArCoreMaterial(color: Colors.red)],
//           radius: 0.1,
//         ),
//         position: vector.Vector3(0, 0, -1), // Position the ball 1m away
//       ),
//     );
//   }
// }
