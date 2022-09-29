import 'dart:async';
import 'dart:convert';

import 'package:csgame/models/player.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PlayersService {
  const PlayersService._();

  static final channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8888/Game'));

  static Stream<List<Player>> playersData() {
    return channel.stream.transform(streamTransformer());
    // _channel.stream.listen(
    //   (stringData) {
    //     final Iterable jsonData = json.decode(stringData)['players'];

    //     final players = List<Player>.from(jsonData.map((playerMap) => Player.fromMap(playerMap)));
    //   },
    // );

    // return _channel.stream.transform(streamTransformer);
    // _channel.stream.listen((message) {
    //   channel.sink.add('received!');
    //   channel.sink.close(status.goingAway);
    // });
  }

  static StreamTransformer<dynamic, List<Player>> streamTransformer() {
    return StreamTransformer.fromHandlers(
      handleData: ((data, sink) {
        final Iterable jsonData = json.decode(data)['players'];

        final players = List<Player>.from(jsonData.map((playerMap) => Player.fromMap(playerMap)));
        sink.add(players);
      }),
    );
  }
}
