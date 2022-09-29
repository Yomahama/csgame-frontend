import 'package:csgame/views/blocs/cubit/authentication_cubit.dart';
import 'package:csgame/views/consts/theme.dart';
import 'package:csgame/views/screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyGame());
}

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationCubit(),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.data,
        home: const AuthenticationScreen(),
      ),
    );
  }
}
