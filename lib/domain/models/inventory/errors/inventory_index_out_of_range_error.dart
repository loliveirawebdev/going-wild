class InventoryIndexOutOfRangeError extends StateError {
  InventoryIndexOutOfRangeError({required int index, required int capacity})
    : super('Index $index is outside an inventory of capacity $capacity');
}
