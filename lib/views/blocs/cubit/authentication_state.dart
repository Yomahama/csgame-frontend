part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {}

class AuthenticationSuccessful extends AuthenticationState {
  final Player player;

  const AuthenticationSuccessful(this.player);

  @override
  List<Object?> get props => [player];
}
