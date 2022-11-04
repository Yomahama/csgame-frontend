import 'package:csgame/logic/services/players_service.dart';
import 'package:csgame/models/player.dart';
import 'package:csgame/models/position.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GameController {
  late WebSocketChannel playersChannel;
  late Stream<List<Player>> playersStream;
  late BuildContext? context;

  late double screenWidth;
  late double screenHeight;

  static final Position _playerPosition = Position.initial();

  GameController({
    required this.playersChannel,
    required this.playersStream,
    this.context,
  });

  void initializePlayersServices() {
    playersChannel = PlayersService.channel;
    playersStream = PlayersService.playersData();
  }

  void initializeScreenSize(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}
