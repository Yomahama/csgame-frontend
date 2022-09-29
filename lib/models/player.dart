import 'dart:convert';

class Player {
  final String username;
  final double x;
  final double y;

  const Player(this.username, this.x, this.y);

  factory Player.start(String username) => Player(username, 0, 0);

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'x': x,
      'y': y,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      map['username'] ?? '',
      map['x']?.toDouble() ?? 0.0,
      map['y']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) => Player.fromMap(json.decode(source));

  Player copyWith({
    String? username,
    double? x,
    double? y,
  }) {
    return Player(
      username ?? this.username,
      x ?? this.x,
      y ?? this.y,
    );
  }
}
