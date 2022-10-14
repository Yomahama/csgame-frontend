import 'package:bloc/bloc.dart';
import 'package:csgame/models/position.dart';
import 'package:equatable/equatable.dart';

part 'cursor_state.dart';

class CursorCubit extends Cubit<CursorState> {
  CursorCubit() : super(CursorState(Position.initial()));

  void updatePosition(Position newPosition) {
    emit(CursorState(newPosition));
  }
}
