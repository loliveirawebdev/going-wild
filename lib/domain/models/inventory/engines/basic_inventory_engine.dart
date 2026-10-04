import 'package:going_wild/domain/models/inventory/engines/inventory_engine.dart';
import 'package:going_wild/domain/models/inventory/inventory.dart';
import 'package:going_wild/domain/models/inventory/inventory_factory.dart';

class BasicInventoryEngine<Entry extends Object> extends InventoryEngine<Entry> {
  const BasicInventoryEngine({required this.capacity});

  @override
  final int capacity;

  @override
  Inventory<Entry> emptyInventory() => InventoryFactory.empty(capacity: capacity);

  @override
  int indexForNewEntry(Inventory<Entry> inventory) => inventory.firstFreeIndex;
}
