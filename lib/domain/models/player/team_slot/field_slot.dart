part of 'team_slot.dart';

class FieldSlot extends TeamSlot {
  const FieldSlot({required this.position});

  final Position position;

  @override
  bool operator ==(Object other) => other is FieldSlot && other.position == position;

  @override
  int get hashCode => position.hashCode;
}
