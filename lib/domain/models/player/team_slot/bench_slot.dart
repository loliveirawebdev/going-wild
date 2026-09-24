part of 'team_slot.dart';

class BenchSlot extends TeamSlot {
  const BenchSlot({required this.index});

  final int index;

  @override
  bool operator ==(Object other) => other is BenchSlot && other.index == index;

  @override
  int get hashCode => index.hashCode;
}
