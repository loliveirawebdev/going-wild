part of 'preparation_state.dart';

class PreparationRejection {
  const PreparationRejection({required this.id, required this.error, required this.event});

  final int id;
  final PreparationEvent event;
  final RejectedPlayerActionError error;

  @override
  String toString() => 'PreparationRejection(#$id, $event: ${error.runtimeType})';
}
