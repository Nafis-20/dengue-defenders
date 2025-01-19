// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:math';

// class TicTacToeGame extends StatefulWidget {
//   const TicTacToeGame({super.key});

//   @override
//   _TicTacToeGameState createState() => _TicTacToeGameState();
// }

// class _TicTacToeGameState extends State<TicTacToeGame> {
//   List<String> board = List.filled(9, "");
//   bool isPlayerOneTurn = true;
//   String message = "Player 1's Turn";
//   Timer? _timer;
//   int _timeRemaining = 30;

//   final List<Map<String, dynamic>> questions = [
//     {
//       'question': "Where do Aedes mosquitoes usually breed?",
//       'options': [
//         "Flowing rivers",
//         "In stagnant water",
//         "On trees",
//         "Inside animals"
//       ],
//       'answer': 1,
//     },
//     {
//       'question':
//           "How often should you empty or clean water containers to prevent mosquito breeding?",
//       'options': [
//         "Once a day",
//         "Every two days",
//         "Once a week",
//         "Once a month"
//       ],
//       'answer': 2,
//     },
//     {
//       'question':
//           "Which of the following can collect stagnant water and attract mosquitoes?",
//       'options': [
//         "Water storage tanks and plant saucers",
//         "Furniture and carpets",
//         "Air conditioners",
//         "Cellphones and cables"
//       ],
//       'answer': 0,
//     },
//     {
//       'question': "Why is it important to cover water containers?",
//       'options': [
//         "To keep water clean",
//         "To prevent mosquitoes from laying eggs",
//         "To stop water from evaporating",
//         "To improve taste"
//       ],
//       'answer': 1,
//     },
//     {
//       'question':
//           "True or False: Aedes mosquitoes can breed in very small amounts of water, even in a bottle cap.",
//       'options': ["True", "False"],
//       'answer': 0,
//     },
//     {
//       'question':
//           "What should you do with old tires or containers that collect water in your backyard?",
//       'options': [
//         "Throw them in the river",
//         "Store them carefully",
//         "Dispose of them or cover them",
//         "Use them as decorations"
//       ],
//       'answer': 2,
//     },
//     {
//       'question': "What are two common symptoms of dengue fever?",
//       'options': [
//         "Sore throat and sneezing",
//         "High fever and severe headache",
//         "Stomach ache and rash",
//         "Cough and chills"
//       ],
//       'answer': 1,
//     },
//     {
//       'question': "What pattern do Aedes mosquitoes have on their body?",
//       'options': [
//         "Green and yellow spots",
//         "Red and black lines",
//         "Black and white stripes",
//         "Blue and white dots"
//       ],
//       'answer': 2,
//     },
//     {
//       'question':
//           "True or False: If you have dengue fever, you should drink plenty of fluids.",
//       'options': ["True", "False"],
//       'answer': 0,
//     },
//     {
//       'question': "What is one way to protect yourself from mosquito bites?",
//       'options': [
//         "Avoid water altogether",
//         "Use mosquito repellent or wear long sleeves and pants",
//         "Drink lemon juice daily",
//         "Use loud noises to scare mosquitoes"
//       ],
//       'answer': 1,
//     },
//     {
//       'question': "When are Aedes mosquitoes most active in biting people?",
//       'options': [
//         "Midnight",
//         "Noon",
//         "Early morning and late afternoon",
//         "Only on rainy days"
//       ],
//       'answer': 2,
//     },
//     {
//       'question':
//           "True or False: Dengue fever can be spread from one person to another directly.",
//       'options': ["True", "False"],
//       'answer': 1,
//     },
//     {
//       'question':
//           "What should you do if someone in your family shows symptoms of dengue fever?",
//       'options': [
//         "Let them rest at home",
//         "Take them to the doctor immediately",
//         "Give them cold water and wait",
//         "Spray mosquito repellent around them"
//       ],
//       'answer': 1,
//     },
//     {
//       'question':
//           "Why is it important to prevent mosquitoes from breeding around your home?",
//       'options': [
//         "To reduce the risk of food poisoning",
//         "To make the area smell better",
//         "To reduce the risk of dengue fever in the community",
//         "To increase water usage"
//       ],
//       'answer': 2,
//     },
//     {
//       'question':
//           "When is National Dengue Prevention Day usually observed in Malaysia?",
//       'options': ["January", "June", "August", "December"],
//       'answer': 1,
//     },
//     {
//       'question': "What kind of mosquito spreads dengue fever?",
//       'options': [
//         "Anopheles mosquito",
//         "Aedes mosquito",
//         "Culex mosquito",
//         "Tabanus mosquito"
//       ],
//       'answer': 1,
//     },
//     {
//       'question': "What does the Aedes mosquito bite to transmit dengue?",
//       'options': [
//         "Only humans",
//         "Humans and other animals",
//         "Only fish",
//         "Birds"
//       ],
//       'answer': 0,
//     },
//     {
//       'question': "What is one common way dengue spreads in communities?",
//       'options': [
//         "Eating contaminated food",
//         "Through infected mosquito bites",
//         "Sharing personal items",
//         "Drinking unclean water"
//       ],
//       'answer': 1,
//     },
//     {
//       'question': "How can communities prevent mosquito breeding?",
//       'options': [
//         "Keep lights on overnight",
//         "Wear shoes inside the house",
//         "Clean and cover water containers",
//         "Plant more trees"
//       ],
//       'answer': 2,
//     },
//     {
//       'question': "How many stages does the Aedes mosquito's life cycle have?",
//       'options': ["2", "4", "3", "5"],
//       'answer': 1,
//     }
//   ];

//   void handleTileTap(int index) {
//     if (board[index] == "") {
//       _askQuestion(index);
//     }
//   }

//   void _askQuestion(int index) {
//     final question = questions[Random().nextInt(questions.length)];
//     _startTimer(() => _handleTimeout(index, question));

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.purple.shade50,
//           title: Text(
//             question['question'],
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: question['options'].asMap().entries.map<Widget>((entry) {
//               final idx = entry.key;
//               final option = entry.value;
//               return ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onPressed: () {
//                   _timer?.cancel();
//                   Navigator.of(context).pop();
//                   _checkAnswer(index, idx == question['answer'], question);
//                 },
//                 child: Text(option),
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   void _handleTimeout(int index, Map<String, dynamic> question) {
//     Navigator.of(context).pop();
//     _showTimeoutDialog(index, question);
//   }

//   void _startTimer(VoidCallback onTimeout) {
//     _timer?.cancel();
//     _timeRemaining = 30;

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_timeRemaining > 0) {
//           _timeRemaining--;
//         } else {
//           _timer?.cancel();
//           onTimeout();
//         }
//       });
//     });
//   }

//   void _showTimeoutDialog(int index, Map<String, dynamic> question) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.red.shade50,
//           title: const Text(
//             "Time's Up!",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.red,
//             ),
//           ),
//           content: Text(
//             "The correct answer is: ${question['options'][question['answer']]}",
//             style: const TextStyle(fontSize: 18),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 setState(() {
//                   isPlayerOneTurn = !isPlayerOneTurn;
//                   message =
//                       isPlayerOneTurn ? "Player 1's Turn" : "Player 2's Turn";
//                 });
//               },
//               child: const Text("OK"),
//             )
//           ],
//         );
//       },
//     );
//   }

//   void _checkAnswer(int index, bool isCorrect, Map<String, dynamic> question) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor:
//               isCorrect ? Colors.green.shade50 : Colors.red.shade50,
//           title: Text(
//             isCorrect ? "Correct!" : "Wrong!",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: isCorrect ? Colors.green : Colors.red,
//             ),
//           ),
//           content: Text(
//             isCorrect
//                 ? "You can make your move."
//                 : "The correct answer is: ${question['options'][question['answer']]}",
//             style: const TextStyle(fontSize: 18),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 if (isCorrect) {
//                   setState(() {
//                     board[index] = isPlayerOneTurn ? "X" : "O";
//                     isPlayerOneTurn = !isPlayerOneTurn;
//                     message =
//                         isPlayerOneTurn ? "Player 1's Turn" : "Player 2's Turn";
//                   });
//                   _checkWinner();
//                 } else {
//                   setState(() {
//                     isPlayerOneTurn = !isPlayerOneTurn;
//                     message =
//                         isPlayerOneTurn ? "Player 1's Turn" : "Player 2's Turn";
//                   });
//                 }
//               },
//               child: const Text("OK"),
//             )
//           ],
//         );
//       },
//     );
//   }

//   void _checkWinner() {
//     const winPatterns = [
//       [0, 1, 2],
//       [3, 4, 5],
//       [6, 7, 8],
//       [0, 3, 6],
//       [1, 4, 7],
//       [2, 5, 8],
//       [0, 4, 8],
//       [2, 4, 6]
//     ];

//     for (var pattern in winPatterns) {
//       if (board[pattern[0]] != "" &&
//           board[pattern[0]] == board[pattern[1]] &&
//           board[pattern[1]] == board[pattern[2]]) {
//         _showGameOverDialog("${board[pattern[0]]} Wins!");
//         return;
//       }
//     }

//     if (board.every((tile) => tile != "")) {
//       _showGameOverDialog("It's a Draw!");
//     }
//   }

//   void _showGameOverDialog(String result) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.blue.shade50,
//           title: Text(
//             "Game Over",
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           content: Text(
//             result,
//             style: const TextStyle(fontSize: 18),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 setState(() {
//                   board = List.filled(9, "");
//                   isPlayerOneTurn = true;
//                   message = "Player 1's Turn";
//                 });
//               },
//               child: const Text("Restart"),
//             )
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dengue Tic Tac Toe"),
//         backgroundColor: Colors.teal,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "$message | Time Left: $_timeRemaining s",
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 mainAxisSpacing: 5,
//                 crossAxisSpacing: 5,
//               ),
//               itemCount: 9,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () => handleTileTap(index),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.teal.shade100,
//                       border: Border.all(color: Colors.teal, width: 2),
//                     ),
//                     child: Center(
//                       child: Text(
//                         board[index],
//                         style: const TextStyle(
//                             fontSize: 36, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:async';
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
  Timer? _timer;
  int _timeRemaining = 15;

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
    {
      'question':
          "How often should you empty or clean water containers to prevent mosquito breeding?",
      'options': [
        "Once a day",
        "Every two days",
        "Once a week",
        "Once a month"
      ],
      'answer': 2,
    },
    {
      'question':
          "Which of the following can collect stagnant water and attract mosquitoes?",
      'options': [
        "Water storage tanks and plant saucers",
        "Furniture and carpets",
        "Air conditioners",
        "Cellphones and cables"
      ],
      'answer': 0,
    },
    {
      'question': "Why is it important to cover water containers?",
      'options': [
        "To keep water clean",
        "To prevent mosquitoes from laying eggs",
        "To stop water from evaporating",
        "To improve taste"
      ],
      'answer': 1,
    },
    {
      'question':
          "True or False: Aedes mosquitoes can breed in very small amounts of water, even in a bottle cap.",
      'options': ["True", "False"],
      'answer': 0,
    },
    {
      'question':
          "What should you do with old tires or containers that collect water in your backyard?",
      'options': [
        "Throw them in the river",
        "Store them carefully",
        "Dispose of them or cover them",
        "Use them as decorations"
      ],
      'answer': 2,
    },
    {
      'question': "What are two common symptoms of dengue fever?",
      'options': [
        "Sore throat and sneezing",
        "High fever and severe headache",
        "Stomach ache and rash",
        "Cough and chills"
      ],
      'answer': 1,
    },
    {
      'question': "What pattern do Aedes mosquitoes have on their body?",
      'options': [
        "Green and yellow spots",
        "Red and black lines",
        "Black and white stripes",
        "Blue and white dots"
      ],
      'answer': 2,
    },
    {
      'question':
          "True or False: If you have dengue fever, you should drink plenty of fluids.",
      'options': ["True", "False"],
      'answer': 0,
    },
    {
      'question': "What is one way to protect yourself from mosquito bites?",
      'options': [
        "Avoid water altogether",
        "Use mosquito repellent or wear long sleeves and pants",
        "Drink lemon juice daily",
        "Use loud noises to scare mosquitoes"
      ],
      'answer': 1,
    },
    {
      'question': "When are Aedes mosquitoes most active in biting people?",
      'options': [
        "Midnight",
        "Noon",
        "Early morning and late afternoon",
        "Only on rainy days"
      ],
      'answer': 2,
    },
    {
      'question':
          "True or False: Dengue fever can be spread from one person to another directly.",
      'options': ["True", "False"],
      'answer': 1,
    },
    {
      'question':
          "What should you do if someone in your family shows symptoms of dengue fever?",
      'options': [
        "Let them rest at home",
        "Take them to the doctor immediately",
        "Give them cold water and wait",
        "Spray mosquito repellent around them"
      ],
      'answer': 1,
    },
    {
      'question':
          "Why is it important to prevent mosquitoes from breeding around your home?",
      'options': [
        "To reduce the risk of food poisoning",
        "To make the area smell better",
        "To reduce the risk of dengue fever in the community",
        "To increase water usage"
      ],
      'answer': 2,
    },
    {
      'question':
          "When is National Dengue Prevention Day usually observed in Malaysia?",
      'options': ["January", "June", "August", "December"],
      'answer': 1,
    },
    {
      'question': "What kind of mosquito spreads dengue fever?",
      'options': [
        "Anopheles mosquito",
        "Aedes mosquito",
        "Culex mosquito",
        "Tabanus mosquito"
      ],
      'answer': 1,
    },
    {
      'question': "What does the Aedes mosquito bite to transmit dengue?",
      'options': [
        "Only humans",
        "Humans and other animals",
        "Only fish",
        "Birds"
      ],
      'answer': 0,
    },
    {
      'question': "What is one common way dengue spreads in communities?",
      'options': [
        "Eating contaminated food",
        "Through infected mosquito bites",
        "Sharing personal items",
        "Drinking unclean water"
      ],
      'answer': 1,
    },
    {
      'question': "How can communities prevent mosquito breeding?",
      'options': [
        "Keep lights on overnight",
        "Wear shoes inside the house",
        "Clean and cover water containers",
        "Plant more trees"
      ],
      'answer': 2,
    },
    {
      'question': "How many stages does the Aedes mosquito's life cycle have?",
      'options': ["2", "4", "3", "5"],
      'answer': 1,
    }
  ];

  void _handleTimeout(int index, Map<String, dynamic> question) {
    Navigator.of(context).pop();
    _showTimeoutDialog(index, question);
  }

  void _startTimer(VoidCallback onTimeout) {
    _timer?.cancel();
    _timeRemaining = 15;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer?.cancel();
          onTimeout();
        }
      });
    });
  }

  void _askQuestion(int index) {
    final question = questions[Random().nextInt(questions.length)];

    _startTimer(() => _handleTimeout(index, question));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.purple.shade50,
              title: Column(
                children: [
                  Text(
                    question['question'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Time left: $_timeRemaining seconds",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    question['options'].asMap().entries.map<Widget>((entry) {
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
                      _timer?.cancel();
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
      },
    );
  }

  void _showTimeoutDialog(int index, Map<String, dynamic> question) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade50,
          title: const Text(
            "Time's Up!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(
            "The correct answer is: ${question['options'][question['answer']]}",
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isPlayerOneTurn = !isPlayerOneTurn;
                  message =
                      isPlayerOneTurn ? "Player 1's Turn" : "Player 2's Turn";
                });
              },
              child: const Text("OK"),
            )
          ],
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
            style: const TextStyle(fontSize: 18),
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
              child: const Text("OK"),
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
          title: const Text(
            "Game Over",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: Text(
            result,
            style: const TextStyle(fontSize: 18),
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
              child: const Text("Restart"),
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
        title: const Text("Dengue Tic Tac Toe"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => board[index] == "" ? _askQuestion(index) : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      border: Border.all(color: Colors.teal, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
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
