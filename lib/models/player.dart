import 'package:csgame/models/position.dart';
import 'package:flutter/material.dart';

class Player {
  final Position position;

  const Player(this.position);

  factory Player.start() => Player(Position.start());

  void goUp() => position.goUp();
  void goDown() => position.goDown();

  Widget figure(Position position) {
    return Positioned(
      top: position.y,
      left: position.x,
      child: Container(
        height: 20,
        width: 20,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
