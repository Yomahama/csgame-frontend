import 'package:csgame/design_patterns/factory_method/blue_team_player_sprite.dart';
import 'package:csgame/design_patterns/factory_method/none_team_player_sprite.dart';
import 'package:csgame/design_patterns/factory_method/player_sprite.dart';
import 'package:csgame/design_patterns/factory_method/red_team_player_sprite.dart';
import 'package:csgame/logic/controllers/game_controller.dart';
import 'package:csgame/logic/controllers/navigation_intents.dart';
import 'package:csgame/logic/services/players_service.dart';
import 'package:csgame/models/player.dart';
import 'package:csgame/models/position.dart';
import 'package:csgame/views/screens/authentication/cubit/authentication_cubit.dart';
import 'package:csgame/views/widgets/custom_cursor/cursor_cubit/cursor_cubit.dart';
import 'package:csgame/views/widgets/custom_cursor/custom_cursor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // late WebSocketChannel _playerChannel;
  // late Stream<List<Player>> _playersStream;

  late final AuthenticationCubit _authenticationCubit;
  late final CursorCubit _cursorCubit;

  late GameController _gameController;

  @override
  void initState() {
    super.initState();

    _authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
    _cursorCubit = BlocProvider.of<CursorCubit>(context);

    _gameController = GameController(
      playersChannel: PlayersService.channel,
      playersStream: PlayersService.playersData(),
    );

    _gameController.initializePlayersServices();
  }

  final _goUpKey = LogicalKeySet(LogicalKeyboardKey.arrowUp);
  final _goDownKey = LogicalKeySet(LogicalKeyboardKey.arrowDown);
  final _goRightKey = LogicalKeySet(LogicalKeyboardKey.arrowRight);
  final _goLeftKey = LogicalKeySet(LogicalKeyboardKey.arrowLeft);

  final double _playerSize = 30.0;
  final double _stepSize = 10.0;

  double _x = 0;
  double _y = 0;

  Position? _mousePositionOnClick;

  final List<PlayerSprite> _playerSprites = [
    BlueTeamPlayerSprite(),
    RedTeamPlayerSprite(),
    NoneTeamPlayerStripe(),
  ];

  @override
  Widget build(BuildContext context) {
    _gameController.initializeScreenSize(context);

    return Listener(
      onPointerDown: _onCursorClicked,
      child: MouseRegion(
        onHover: _onCursorPositionChanged,
        cursor: SystemMouseCursors.none,
        child: Scaffold(
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
            child: Stack(
              children: [
                _buildPlayers(),
                if (_mousePositionOnClick != null) _builShootDirection(),
                _buildCursor(),
                _buildPlayersHealthBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _builShootDirection() {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: LineDrawer(
        Offset(_x + _playerSize / 2, _y + _playerSize / 2),
        Offset(
          _mousePositionOnClick!.x,
          _mousePositionOnClick!.y,
        ),
      ),
    );
  }

  Widget _buildCursor() {
    return BlocBuilder<CursorCubit, CursorState>(
      builder: (context, state) {
        return Positioned(
          top: state.position.y - 12, // -12 so that offset would be in the center
          left: state.position.x - 12,
          child: const CustomCursor(),
        );
      },
    );
  }

  void _onCursorClicked(PointerDownEvent pointerDownEvent) {
    setState(() {
      _mousePositionOnClick = Position(
        pointerDownEvent.position.dx,
        pointerDownEvent.position.dy,
      );
    });
  }

  Widget _buildPlayers() {
    return StreamBuilder<List<Player>>(
      stream: _gameController.playersStream,
      initialData: const [],
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final players = snapshot.data!;

            int myIndex = players.indexWhere(
              (p) => p.username == _authenticationCubit.player.username,
            );

            players[myIndex] = players[myIndex].copyWith(
              teamChoice: _authenticationCubit.player.teamChoice,
            );

            return Stack(
              children: [
                for (int i = 0; i < players.length; i++) _buildPlayerSprite(players[i]),
              ],
            );
          }
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(
              '-> PRESS ANY ARROW KEY TO START <-',
              style: TextStyle(fontSize: 24),
            ),
          );
        }

        return Center(child: Text(snapshot.connectionState.name));
      },
    );
  }

  //Strategy, Builder, Prototype //abstract factory //command //adapter

  Widget _buildPlayerSprite(Player player) {
    return Positioned(
      top: player.position.y,
      left: player.position.x,
      child: _playerSprites[player.teamChoice.index].show(player),
    );
  }

  Widget _buildPlayersHealthBar() {
    return Positioned.fill(
      child: Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.topCenter,
        child: Row(
          children: [
            for (int i = 0; i < 10; i++) const Icon(Icons.favorite_border_rounded),
            const Spacer(),
            for (int i = 0; i < 10; i++) const Icon(Icons.favorite_border_rounded),
          ],
        ),
      ),
    );
  }

  bool _canGoWidth(double currentPos) {
    return 0 < currentPos - _stepSize + _playerSize / 2 &&
        currentPos - _stepSize + _playerSize / 2 < _gameController.screenWidth;
  }

  bool _canGoHeight(double currentPos) {
    return 0 < currentPos - _stepSize + _playerSize / 2 &&
        currentPos - _stepSize + _playerSize / 2 < _gameController.screenHeight;
  }

  void _notifyThatReachedBounds() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('You have reach the bounds of the map'),
      duration: Duration(seconds: 1),
    ));
  }

  Intent _goUp(Intent intent) {
    if (_canGoHeight(_y - _stepSize)) {
      _y = _y - _stepSize;

      _gameController.playersChannel.sink
          .add(_authenticationCubit.player.copyWith(position: Position(_x, _y)).toJson());
    } else {
      _notifyThatReachedBounds();
    }

    return intent;
  }

  Intent _goDown(Intent intent) {
    if (_canGoHeight(_y + _stepSize)) {
      _y = _y + _stepSize;
      _gameController.playersChannel.sink
          .add(_authenticationCubit.player.copyWith(position: Position(_x, _y)).toJson());
    } else {
      _notifyThatReachedBounds();
    }

    return intent;
  }

  Intent _goRight(Intent intent) {
    if (_canGoWidth(_x + _stepSize)) {
      _x = _x + _stepSize;
      _gameController.playersChannel.sink
          .add(_authenticationCubit.player.copyWith(position: Position(_x, _y)).toJson());
    } else {
      _notifyThatReachedBounds();
    }
    return intent;
  }

  Intent _goLeft(Intent intent) {
    if (_canGoWidth(_x - _stepSize)) {
      _x = _x - _stepSize;
      _gameController.playersChannel.sink
          .add(_authenticationCubit.player.copyWith(position: Position(_x, _y)).toJson());
    } else {
      _notifyThatReachedBounds();
    }
    return intent;
  }

// fetches mouse pointer location
  void _onCursorPositionChanged(PointerEvent details) {
    _cursorCubit.updatePosition(
      Position(details.position.dx, details.position.dy),
    );
  }
}

class LineDrawer extends CustomPainter {
  final Offset start;
  final Offset end;

  const LineDrawer(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan
      ..strokeWidth = 2;
    // canvas.draw

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
