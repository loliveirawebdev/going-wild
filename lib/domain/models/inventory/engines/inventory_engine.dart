import '../inventory.dart';

abstract class InventoryEngine<Entry extends Object> {
  const InventoryEngine();

  int get capacity;
  Inventory<Entry> emptyInventory();
  int indexForNewEntry(Inventory<Entry> inventory);
}
