class EmptyInventorySlotError extends StateError {
  EmptyInventorySlotError({required int index}) : super('Inventory slot $index is empty');
}
