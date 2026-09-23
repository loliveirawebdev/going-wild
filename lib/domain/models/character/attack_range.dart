enum AttackRange {
  melee(cells: 1),
  midRange(cells: 2),
  longRange(cells: 4);

  const AttackRange({required this.cells});
  final int cells;
}
