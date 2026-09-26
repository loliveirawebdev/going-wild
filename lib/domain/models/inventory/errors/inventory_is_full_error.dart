class InventoryIsFullError extends StateError {
  InventoryIsFullError() : super('The inventory has no free slot');
}
