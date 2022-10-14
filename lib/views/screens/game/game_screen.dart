import 'package:csgame/logic/services/players_service.dart';
import 'package:csgame/models/player.dart';
import 'package:csgame/models/position.dart';
import 'package:csgame/views/screens/authentication/cubit/authentication_cubit.dart';
import 'package:csgame/views/screens/game/cubits/cursor_cubit/cursor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
  late final CursorCubit _cursorCubit;

  late double _screenHeight;
  late double _screenWidth;

  @override
  void initState() {
    super.initState();

    _authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
    _cursorCubit = BlocProvider.of<CursorCubit>(context);

    _playerChannel = PlayersService.channel;

    _playersStream = PlayersService.playersData();
  }

  final _goUpKey = LogicalKeySet(LogicalKeyboardKey.arrowUp);
  final _goDownKey = LogicalKeySet(LogicalKeyboardKey.arrowDown);
  final _goRightKey = LogicalKeySet(LogicalKeyboardKey.arrowRight);
  final _goLeftKey = LogicalKeySet(LogicalKeyboardKey.arrowLeft);

  double _x = 0;
  double _y = 0;

  Position? _mousePositionOnClick;
  final Position _playerPosition = Position.initial();

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
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
        Offset(
          _x + 30,
          _y + 30,
        ),
        Offset(
          _mousePositionOnClick!.x,
          _mousePositionOnClick!.y,
        ),
      ),
    );
  }

  // Positioned(
  //   top: 0,
  //   right: 200,
  //   child: Container(
  //     color: Colors.deepPurple,
  //     width: 20,
  //     height: 100,
  //   ),
  // ),
  //random object

  Widget _buildCursor() {
    return BlocBuilder<CursorCubit, CursorState>(
      builder: (context, state) {
        print('build');
        return Positioned(
          top: state.position.y - 12,
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
      stream: _playersStream,
      initialData: const [],
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final players = snapshot.data!;

            return Stack(
              children: [
                for (int i = 0; i < players.length; i++)
                  _buildPlayerSprite(
                    players[i].position,
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
    );
  }

  Widget _buildPlayerSprite(Position position, Color color) {
    return Positioned(
      top: position.y,
      left: position.x,
      child: SvgPicture.asset(
        'assets/images/character.svg',
        height: 60,
        width: 60,
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

      _playerChannel.sink
          .add(_authenticationCubit.player.copyWith(position: Position(_x, _y)).toJson());
    } else {
      _notifyThatNotAvailable();
    }

    return intent;
  }

  Intent _goDown(Intent intent) {
    if (_canGoHeight(_y + 10)) {
      _y = _y + 10;
      _playerChannel.sink
          .add(_authenticationCubit.player.copyWith(position: Position(_x, _y)).toJson());
    } else {
      _notifyThatNotAvailable();
    }

    return intent;
  }

  Intent _goRight(Intent intent) {
    if (_canGoWidth(_x + 10)) {
      _x = _x + 10;
      _playerChannel.sink
          .add(_authenticationCubit.player.copyWith(position: Position(_x, _y)).toJson());
    } else {
      _notifyThatNotAvailable();
    }
    return intent;
  }

  Intent _goLeft(Intent intent) {
    if (_canGoWidth(_x - 10)) {
      _x = _x - 10;
      _playerChannel.sink
          .add(_authenticationCubit.player.copyWith(position: Position(_x, _y)).toJson());
    } else {
      _notifyThatNotAvailable();
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

class GoUpIntent extends Intent {}

class GoDownIntent extends Intent {}

class GoLeftIntent extends Intent {}

class GoRightIntent extends Intent {}

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

class CustomCursor extends StatefulWidget {
  const CustomCursor({super.key});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor> {
  @override
  Widget build(BuildContext context) {
    print('cursor');
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 24,
            width: 2,
            color: Colors.grey,
          ),
          Container(
            height: 2,
            width: 24,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
