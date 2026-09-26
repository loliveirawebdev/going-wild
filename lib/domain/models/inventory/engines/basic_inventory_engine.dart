import '../inventory.dart';
import '../inventory_factory.dart';
import 'inventory_engine.dart';

class BasicInventoryEngine<Entry extends Object> extends InventoryEngine<Entry> {
  const BasicInventoryEngine({required this.capacity});

  @override
  final int capacity;

  @override
  Inventory<Entry> emptyInventory() => InventoryFactory.empty(capacity: capacity);

  @override
  int indexForNewEntry(Inventory<Entry> inventory) => inventory.firstFreeIndex;
}
