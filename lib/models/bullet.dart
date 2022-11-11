import 'dart:convert';

import 'package:csgame/models/entity_base.dart';
import 'package:csgame/models/enums.dart';
import 'package:csgame/models/player.dart';
import 'package:csgame/models/position.dart';
import 'package:equatable/equatable.dart';

class Bullet extends Equatable with EntityBase{
  final Player player;
  final Position target;
  final String? hitUsername;
  const Bullet({required this.player, required this.target, this.hitUsername});

  @override
  List<Object?> get props => [player, target, hitUsername];

  Map<String, dynamic> toMap() {
    return {
      'username': player.username,
      'x': player.position.x,
      'y': player.position.y,
      'target_x': target.x,
      'target_y': target.y,
    };
  }

  factory Bullet.fromMap(Map<String, dynamic> map) {
    return Bullet(
      player: Player(
        map['username'].toString(),
        TeamChoice.none,
        Position(map['x']?.toDouble() ?? 0.0, map['y'].toDouble() ?? 0.0),
      ),
      target: Position.fromMap(map),
      hitUsername: map['hit_target_username']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bullet.fromJson(String source) => Bullet.fromMap(json.decode(source));
  
}
