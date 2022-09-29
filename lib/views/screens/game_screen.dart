import 'package:csgame/logic/services/players_service.dart';
import 'package:csgame/models/player.dart';
import 'package:csgame/views/blocs/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late WebSocketChannel _playerChannel;
  late Stream<List<Player>> _playersStream;

  late final AuthenticationCubit _authenticationCubit;

  late double _screenHeight;
  late double _screenWidth;

  @override
  void initState() {
    super.initState();

    _authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);

    _playerChannel = PlayersService.channel;
    _playersStream = PlayersService.playersData();
  }

  final _goUpKey = LogicalKeySet(LogicalKeyboardKey.arrowUp);
  final _goDownKey = LogicalKeySet(LogicalKeyboardKey.arrowDown);
  final _goRightKey = LogicalKeySet(LogicalKeyboardKey.arrowRight);
  final _goLeftKey = LogicalKeySet(LogicalKeyboardKey.arrowLeft);

  double _x = 0;
  double _y = 0;

  late double _playerCoordinateX;
  late double _playerCoordinateY;

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FocusableActionDetector(
        autofocus: true,
        shortcuts: {
          _goUpKey: GoUpIntent(),
          _goDownKey: GoDownIntent(),
          _goRightKey: GoRightIntent(),
          _goLeftKey: GoLeftIntent(),
        },
        actions: {
          GoUpIntent: CallbackAction(onInvoke: _goUp),
          GoDownIntent: CallbackAction(onInvoke: _goDown),
          GoRightIntent: CallbackAction(onInvoke: _goRight),
          GoLeftIntent: CallbackAction(onInvoke: _goLeft),
        },
        child: StreamBuilder<List<Player>>(
          stream: _playersStream,
          initialData: const [],
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                final players = snapshot.data!;
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 200,
                      child: Container(
                        color: Colors.deepPurple,
                        width: 20,
                        height: 100,
                      ),
                    ),
                    for (int i = 0; i < players.length; i++)
                      _buildPlayer(
                        players[i].x,
                        players[i].y,
                        i == 0 ? Colors.red : Colors.blue,
                      ),
                  ],
                );
              }

              return const Center(child: Text('No data'));
            }

            if (snapshot.hasError) {
              print(snapshot.error);
            }

            return Center(child: Text(snapshot.connectionState.name));
          },
        ),
      ),
    );
  }

  Widget _buildPlayer(
    double x,
    double y,
    Color color,
  ) {
    return Positioned(
      top: y,
      left: x,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  bool _canGoWidth(double currentPos) {
    return 0 < currentPos - 10 + 20 && currentPos - 10 + 20 < _screenWidth;
  }

  bool _canGoHeight(double currentPos) {
    return 0 < currentPos - 10 + 20 && currentPos - 10 + 20 < _screenHeight;
  }

  void _notifyThatNotAvailable() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('You have reach the bounds of the map'),
      duration: Duration(seconds: 1),
    ));
  }

  Intent _goUp(Intent intent) {
    if (_canGoHeight(_y - 10)) {
      _y = _y - 10;
      print(_y);
      _playerChannel.sink.add(_authenticationCubit.player.copyWith(x: _x, y: _y).toJson());
    } else {
      _notifyThatNotAvailable();
    }

    return intent;
  }

  Intent _goDown(Intent intent) {
    if (_canGoHeight(_y + 10)) {
      _y = _y + 10;
      _playerChannel.sink.add(_authenticationCubit.player.copyWith(x: _x, y: _y).toJson());
    } else {
      _notifyThatNotAvailable();
    }

    return intent;
  }

  Intent _goRight(Intent intent) {
    if (_canGoWidth(_x + 10)) {
      _x = _x + 10;
      _playerChannel.sink.add(_authenticationCubit.player.copyWith(x: _x, y: _y).toJson());
    } else {
      _notifyThatNotAvailable();
    }
    return intent;
  }

  Intent _goLeft(Intent intent) {
    if (_canGoWidth(_x - 10)) {
      _x = _x - 10;
      _playerChannel.sink.add(_authenticationCubit.player.copyWith(x: _x, y: _y).toJson());
    } else {
      _notifyThatNotAvailable();
    }
    return intent;
  }
}

class GoUpIntent extends Intent {}

class GoDownIntent extends Intent {}

class GoLeftIntent extends Intent {}

class GoRightIntent extends Intent {}
