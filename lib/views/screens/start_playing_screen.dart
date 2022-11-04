import 'package:csgame/models/enums.dart';
import 'package:csgame/views/screens/authentication/cubit/authentication_cubit.dart';
import 'package:csgame/views/screens/game/game_screen.dart';
import 'package:csgame/views/widgets/custom_cursor/cursor_cubit/cursor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartPlayingScreen extends StatelessWidget {
  const StartPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              const Text(
                "SELECT YOUR TEAM:",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(height: 250),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AuthenticationCubit>(context).setTeam(TeamChoice.red);
                      _navigateToGame(context);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AuthenticationCubit>(context).setTeam(TeamChoice.blue);
                      _navigateToGame(context);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGame(BuildContext context) {
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
  }
}
