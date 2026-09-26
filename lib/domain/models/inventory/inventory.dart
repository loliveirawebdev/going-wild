import 'errors/inventory_index_out_of_range_error.dart';
import 'errors/inventory_is_full_error.dart';

class Inventory<Entry extends Object> {
  const Inventory({required this._slots});
  final List<Entry?> _slots;

  int get capacity => _slots.length;
  bool get isFull => !_slots.contains(null);
  List<Entry> get entries => _slots.nonNulls.toList();

  List<({int index, Entry entry})> get indexedEntries => [
    for (final (index, entry) in _slots.indexed)
      if (entry != null) (index: index, entry: entry),
  ];

  int get firstFreeIndex {
    if (isFull) throw InventoryIsFullError();
    return _slots.indexOf(null);
  }

  Entry? entryAt(int index) {
    _checkIndex(index);
    return _slots[index];
  }

  bool _isValidIndex(int index) => index >= 0 && index < _slots.length;
  Inventory<Entry> createCopyWithoutEntryAt(int index) => _withSlot(index, null);
  Inventory<Entry> createCopyWithEntryAt(int index, Entry entry) => _withSlot(index, entry);

  Inventory<Entry> _withSlot(int index, Entry? entry) {
    _checkIndex(index);
    final newSlots = [..._slots];

    newSlots[index] = entry;
    return Inventory(slots: List.unmodifiable(newSlots));
  }

  void _checkIndex(int index) {
    if (!_isValidIndex(index)) {
      throw InventoryIndexOutOfRangeError(
        index: index,
        capacity: capacity,
      );
    }
  }
}
