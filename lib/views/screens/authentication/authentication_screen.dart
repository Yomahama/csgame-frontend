import 'package:csgame/helpers/input_formatter.dart';
import 'package:csgame/views/screens/authentication/cubit/authentication_cubit.dart';
import 'package:csgame/views/screens/start_playing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _usernameController = TextEditingController();

  late final AuthenticationCubit _authenticationCubit;

  @override
  void initState() {
    super.initState();
    _authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ENTER YOUR USERNAME:',
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 100),
            SizedBox(
              width: 400,
              child: TextField(
                controller: _usernameController,
                maxLength: 30,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'Username'),
                inputFormatters: [UpperCaseTextFormatter()],
              ),
            ),
            const SizedBox(height: 80),
            SizedBox(
              height: 60,
              width: 200,
              child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
                listener: (context, state) {
                  if (state is AuthenticationSuccessful) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StartPlayingScreen()),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_usernameController.text.trim().isNotEmpty) {
                        _authenticationCubit.signIn(_usernameController.text);
                      }
                    },
                    child: state is AuthenticationLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'LOG ME IN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
