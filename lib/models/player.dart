import 'dart:convert';

import 'package:csgame/models/position.dart';

class Player {
  final String username;
  final Position position;

  const Player(this.username, this.position);

  factory Player.start(String username) => Player(username, Position.initial());

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'x': position.x,
      'y': position.y,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      map['username'] ?? '',
      Position(
        map['x']?.toDouble() ?? 0.0,
        map['y']?.toDouble() ?? 0.0,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) => Player.fromMap(json.decode(source));

  Player copyWith({String? username, Position? position}) {
    return Player(
      username ?? this.username,
      position ?? this.position,
    );
  }
}
