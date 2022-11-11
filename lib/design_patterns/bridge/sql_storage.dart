import 'package:csgame/design_patterns/bridge/storage_interface.dart';
import 'package:csgame/models/position.dart';

import '../../models/entity_base.dart';

class SqlStorage implements IStorage {
  final Map<Type, List<EntityBase>> sqlStorage = {};

  @override
  Position getPosition() {
    return Position.initial();
  }

  @override
  List<T> fetchAll<T extends EntityBase>() {
    return sqlStorage.containsKey(T) ? sqlStorage[T]! as List<T> : [];
  }

  @override
  void store<T extends EntityBase>(T entityBase) {
    if (!sqlStorage.containsKey(T)) {
      sqlStorage[T] = <T>[];
    }

    sqlStorage[T]!.add(entityBase);
  }
}
