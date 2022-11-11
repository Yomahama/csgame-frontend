import 'package:csgame/design_patterns/bridge/repository_interface.dart';
import 'package:csgame/design_patterns/bridge/storage_interface.dart';
import 'package:csgame/models/bullet.dart';

import '../../models/entity_base.dart';

class BulletsRepository implements IRepository {
  final IStorage storage;

  const BulletsRepository(this.storage);

  @override
  List<EntityBase> getAll() {
    return storage.fetchAll<Bullet>();
  }

  @override
  void save(EntityBase entityBase) {
    storage.store<Bullet>(entityBase as Bullet);
  }
}
