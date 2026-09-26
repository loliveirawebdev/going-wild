class PlayerLevel {
  const PlayerLevel({required this.number, required this.teamSize, required this.experienceToNextLevel});

  final int number;
  final int teamSize;
  final int experienceToNextLevel;

  @override
  bool operator ==(Object other) => other is PlayerLevel && other.number == number;

  @override
  int get hashCode => number.hashCode;
}
