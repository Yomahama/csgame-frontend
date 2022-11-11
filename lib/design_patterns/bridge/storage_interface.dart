import 'package:csgame/models/position.dart';

import '../../models/entity_base.dart';

abstract class IStorage {
  Position getPosition();
  List<T> fetchAll<T extends EntityBase>();
  void store<T extends EntityBase>(T entityBase);
}
