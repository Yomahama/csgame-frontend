import 'package:web_socket_channel/web_socket_channel.dart';

class GameService {
  const GameService._();

  void connectPlayersWebSocket() {
    WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8888/Game'));
  }
}
