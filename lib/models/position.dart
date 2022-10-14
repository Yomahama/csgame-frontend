import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final double x;
  final double y;

  const Position(this.x, this.y);

  factory Position.initial() => const Position(0, 0);

  @override
  List<Object?> get props => [x, y];
}
