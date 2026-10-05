enum PaintedScene {
  splash('splash.jpg');

  final String fileName;
  const PaintedScene(this.fileName);

  String get assetPath => 'assets/scenes/$fileName';
}
