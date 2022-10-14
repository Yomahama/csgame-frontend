import 'package:csgame/models/player.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> signIn(String username) async {
    emit(AuthenticationLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(AuthenticationSuccessful(Player.start(username)));
  }

  Player get player => (state as AuthenticationSuccessful).player;
}
