enum InterfaceGlyph {
  info,
  star,
  plus,
  back,
  play,
  next,
  exit,
  check,
  close,
  alert,
  minus,
  pause,
  settings;

  String get assetPath => 'assets/glyphs/$name.svg';
}
