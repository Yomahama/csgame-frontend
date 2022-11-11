import 'dart:convert';

import 'package:csgame/models/bullet.dart';
import 'package:csgame/models/player.dart';

import '../../models/entity_base.dart';

class JsonHelper {
  const JsonHelper._();

  static String serialiseObject(EntityBase entityBase) {
    return jsonEncode(entityBase);
  }

  static T deserialiseObject<T extends EntityBase>(String jsonString) {
    final json = jsonDecode(jsonString)! as Map<String, dynamic>;

    switch (T) {
      case Bullet:
        return Bullet.fromMap(json) as T;
      case Player:
        return Player.fromMap(json) as T;
      default:
        throw Exception("Type of '$T' is not supported.");
    }
  }
}
