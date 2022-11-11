import 'package:csgame/design_patterns/bridge/storage_interface.dart';
import 'package:csgame/models/position.dart';

import '../../models/entity_base.dart';
import 'json_helper.dart';

class FileStorage implements IStorage {
  final Map<Type, List<String>> fileStorage = {};

  @override
  Position getPosition() {
    return Position.initial();
  }

  @override
  List<T> fetchAll<T extends EntityBase>() {
    if (fileStorage.containsKey(T)) {
      final files = fileStorage[T]!;

      return files.map<T>((f) => JsonHelper.deserialiseObject<T>(f)).toList();
    }

    return [];
  }

  @override
  void store<T extends EntityBase>(T entityBase) {
    if (!fileStorage.containsKey(T)) {
      fileStorage[T] = [];
    }

    fileStorage[T]!.add(JsonHelper.serialiseObject(entityBase));
  }
}
