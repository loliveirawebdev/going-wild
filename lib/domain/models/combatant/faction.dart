enum Faction {
  team,
  enemy;

  Faction get opposingFaction => this == team ? enemy : team;
}
