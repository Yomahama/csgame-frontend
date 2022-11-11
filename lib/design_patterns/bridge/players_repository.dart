import 'package:csgame/design_patterns/bridge/repository_interface.dart';
import 'package:csgame/design_patterns/bridge/storage_interface.dart';
import 'package:csgame/models/player.dart';

import '../../models/entity_base.dart';

class PlayersRepository implements IRepository {
  final IStorage storage;

  const PlayersRepository(this.storage);

  @override
  List<EntityBase> getAll() {
    return storage.fetchAll<Player>();
  }

  @override
  void save(EntityBase entityBase) {
    storage.store<Player>(entityBase as Player);
  }
}
