import 'package:csgame/design_patterns/factory_method/player_sprite.dart';
import 'package:csgame/models/player.dart';
import 'package:csgame/views/consts/global_consts.dart';
import 'package:flutter/material.dart';

class RedTeamPlayerSprite extends PlayerSprite {
  @override
  Widget create(Player player) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: GlobalConsts.playerSize,
          width: GlobalConsts.playerSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        ),
        Positioned(
          top: -15,
          child: Text(
            player.username,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
