part of 'cursor_cubit.dart';

class CursorState extends Equatable {
  final Position position;
  const CursorState(this.position);

  @override
  List<Object> get props => [position];
}
