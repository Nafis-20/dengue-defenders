// File: lib/user/play_snake_game.dart
import 'package:flutter/material.dart';

class PlaySnakeGame extends StatelessWidget {
  const PlaySnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Play Snake-Ladder Game"),
      ),
      body: Center(
        child: const Text(
          "This is the Snake-Ladder Game page.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
