import 'package:csgame/models/player.dart';
import 'package:flutter/material.dart';

abstract class PlayerSprite {
  Widget create(Player player);

  Widget show(Player player) {
    final sprite = create(player);

    return sprite;
  }
}
