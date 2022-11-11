import 'package:csgame/models/player.dart';
import 'package:flutter/material.dart';

abstract class PlayerSprite {
  Widget create(Player player);

  //any method to add

  Widget show(Player player) {
    final sprite = create(player);

    return sprite;
  }
}
