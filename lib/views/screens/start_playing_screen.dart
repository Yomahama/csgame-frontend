import 'package:csgame/views/screens/game/cubits/cursor_cubit/cursor_cubit.dart';
import 'package:csgame/views/screens/game/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => CursorCubit(),
                    ),
                  ],
                  child: const GameScreen(),
                );
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
