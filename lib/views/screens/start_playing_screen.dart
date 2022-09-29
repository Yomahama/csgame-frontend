import 'package:csgame/views/screens/game_screen.dart';
import 'package:flutter/material.dart';

class StartPlayingScreen extends StatelessWidget {
  const StartPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 80,
          width: 400,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const GameScreen();
              }));
            },
            child: const Text(
              'START GAME',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
