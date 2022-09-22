import 'package:csgame/models/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _goUpKey = LogicalKeySet(LogicalKeyboardKey.arrowUp);
  final _goDownKey = LogicalKeySet(LogicalKeyboardKey.arrowDown);
  final _goRightKey = LogicalKeySet(LogicalKeyboardKey.arrowRight);
  final _goLeftKey = LogicalKeySet(LogicalKeyboardKey.arrowLeft);

  final Player player = Player.start();

  double _x = 0;
  double _y = 0;

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          children: [
            _buildPlayer(_x, _y),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer(double x, double y) {
    return Positioned(
      top: y,
      left: x,
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

  Intent _goUp(Intent intent) {
    setState(() {
      // player.goUp();
      _y = _y - 10;
    });

    return intent;
  }

  Intent _goDown(Intent intent) {
    setState(() {
      _y = _y + 10;
      // player.goDown();
    });

    return intent;
  }

  Intent _goRight(Intent intent) {
    setState(() {
      _x = _x + 10;
    });

    return intent;
  }

  Intent _goLeft(Intent intent) {
    setState(() {
      _x = _x - 10;
    });

    return intent;
  }
}

class GoUpIntent extends Intent {}

class GoDownIntent extends Intent {}

class GoLeftIntent extends Intent {}

class GoRightIntent extends Intent {}
