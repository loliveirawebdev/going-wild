import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:going_wild/domain/models/character/sprite/character_sprite.dart';

const atlasCellSize = Size(432, 558);
const atlasAnchor = Offset(216, 372);
const atlasToBoardScale = 0.414815;

const _headRow = 1;

typedef _FrameKey = ({int row, int column});

class AtlasFrame {
  const AtlasFrame({required this.source, required this.offsetFromAnchor});

  final Rect source;
  final Offset offsetFromAnchor;

  Rect get destination => offsetFromAnchor & source.size;
}

class UnitAtlas {
  const UnitAtlas._({required this.image, required this._frames});

  final Image image;
  final Map<_FrameKey, AtlasFrame> _frames;

  static final _loadedByPath = <String, UnitAtlas>{};
  static final _loadingByPath = <String, Future<UnitAtlas>>{};

  static UnitAtlas? loadedFor(CharacterSprite sprite) => _loadedByPath[sprite.atlasPath];

  static Future<UnitAtlas> of(CharacterSprite sprite) async {
    final atlasPath = sprite.atlasPath;
    if (_loadedByPath[atlasPath] case final loadedAtlas?) return loadedAtlas;

    final atlas = await (_loadingByPath[atlasPath] ??= _load(atlasPath));
    return _loadedByPath[atlasPath] = atlas;
  }

  AtlasFrame? frameAt({required int row, required int column}) => _frames[(row: row, column: column)];

  double get headHeightAboveAnchor => -(frameAt(row: _headRow, column: 0)?.offsetFromAnchor.dy ?? 0);

  static Future<UnitAtlas> _load(String atlasPath) async {
    final framesPath = atlasPath.replaceFirst(RegExp(r'\.webp$'), '.json');
    final (bytes, framesJson) = await (rootBundle.load(atlasPath), rootBundle.loadString(framesPath)).wait;
    final codec = await instantiateImageCodec(bytes.buffer.asUint8List());

    return UnitAtlas._(image: (await codec.getNextFrame()).image, frames: _framesFrom(framesJson));
  }

  static Map<_FrameKey, AtlasFrame> _framesFrom(String framesJson) {
    final frames = (jsonDecode(framesJson) as Map<String, dynamic>)['frames'] as List<dynamic>;

    return {
      for (final frame in frames.cast<Map<String, dynamic>>())
        (row: frame['row'] as int, column: frame['column'] as int): AtlasFrame(
          source: Rect.fromLTWH(
            (frame['x'] as int).toDouble(),
            (frame['y'] as int).toDouble(),
            (frame['width'] as int).toDouble(),
            (frame['height'] as int).toDouble(),
          ),
          offsetFromAnchor: Offset((frame['offsetX'] as int).toDouble(), (frame['offsetY'] as int).toDouble()),
        ),
    };
  }
}
