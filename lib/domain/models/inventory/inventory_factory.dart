import 'package:going_wild/domain/models/inventory/inventory.dart';

class InventoryFactory {
  static Inventory<Entry> empty<Entry extends Object>({required int capacity}) {
    return Inventory(slots: List.unmodifiable(List<Entry?>.filled(capacity, null)));
  }
}
