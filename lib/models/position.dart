import 'dart:convert';

import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final double x;
  final double y;

  const Position(this.x, this.y);

  factory Position.initial() => const Position(0, 0);

  @override
  List<Object?> get props => [x, y];

  Position copyWith({
    double? x,
    double? y,
  }) {
    return Position(
      x ?? this.x,
      y ?? this.y,
    );
  }

  factory Position.fromMap(Map<String, dynamic> map) {
    return Position(
      map['target_x']?.toDouble() ?? 0.0,
      map['target_y']?.toDouble() ?? 0.0,
    );
  }


  factory Position.fromJson(String source) => Position.fromMap(json.decode(source));
}
