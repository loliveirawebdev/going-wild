import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart';

const _cellWidth = 432;
const _cellHeight = 558;
const _anchorX = 216;
const _anchorY = 372;
const _rowCount = 5;
const _columnCount = 6;
const _framePadding = 2;
const _shelfWidth = 2048;

const _contentFolderByDeliveredName = {
  'galinha': 'team/chicken',
  'galo': 'team/rooster',
  'pato': 'team/duck',
  'coelho': 'team/rabbit',
  'vaca': 'team/cow',
  'touro': 'team/bull',
  'gato': 'team/cat',
  'cachorro': 'team/dog',
  'bode': 'team/goat',
  'porquinho-da-india': 'team/guinea_pig',
  'cavalo': 'team/horse',
  'abelha': 'team/queen_bee',
  'ovelha': 'team/sheep',
  'porco': 'team/sow',
  'jacare': 'enemies/alligator',
  'morcego': 'enemies/bat',
  'urso': 'enemies/bear',
  'javali': 'enemies/boar',
  'cerbero': 'enemies/cerberus',
  'dragao': 'enemies/dragon',
  'raposa': 'enemies/fox',
  'aranha-gigante': 'enemies/giant_spider',
  'gaviao': 'enemies/hawk',
  'kraken': 'enemies/kraken',
  'coruja': 'enemies/owl',
  'rato': 'enemies/rat',
  'gamba': 'enemies/skunk',
  'cobra': 'enemies/snake',
};

typedef _Crop = ({int row, int column, int x, int y, int width, int height});
typedef _Placement = ({_Crop crop, int x, int y});

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1) {
    stderr.writeln('Usage: dart run tool/pack_unit_atlases.dart <folder with the delivered <name>.png atlases>');
    exit(64);
  }

  for (final MapEntry(key: deliveredName, value: contentFolder) in _contentFolderByDeliveredName.entries) {
    final atlas = decodePng(File('${arguments.single}/$deliveredName.png').readAsBytesSync())!;
    final placements = _shelfPacked(_cropsOf(atlas));
    final destination = 'lib/content/character/$contentFolder';

    await _writePackedImage(atlas, placements, to: '$destination/atlas.webp');
    File('$destination/atlas.json').writeAsStringSync(_framesJsonOf(placements));
    stdout.writeln('$deliveredName → $destination');
  }
}

List<_Crop> _cropsOf(Image atlas) => [
  for (var row = 0; row < _rowCount; row++)
    for (var column = 0; column < _columnCount; column++) ?_cropOfCell(atlas, row: row, column: column),
];

_Crop? _cropOfCell(Image atlas, {required int row, required int column}) {
  final cellLeft = column * _cellWidth;
  final cellTop = row * _cellHeight;
  var (left, top, right, bottom) = (_cellWidth, _cellHeight, -1, -1);

  for (var y = 0; y < _cellHeight; y++) {
    for (var x = 0; x < _cellWidth; x++) {
      if (atlas.getPixel(cellLeft + x, cellTop + y).a == 0) continue;
      if (x < left) left = x;
      if (x > right) right = x;
      if (y < top) top = y;
      if (y > bottom) bottom = y;
    }
  }

  if (right < 0) return null;

  final x = (left - _framePadding).clamp(0, _cellWidth);
  final y = (top - _framePadding).clamp(0, _cellHeight);
  return (
    row: row,
    column: column,
    x: x,
    y: y,
    width: (right + 1 + _framePadding).clamp(0, _cellWidth) - x,
    height: (bottom + 1 + _framePadding).clamp(0, _cellHeight) - y,
  );
}

List<_Placement> _shelfPacked(List<_Crop> crops) {
  final tallestFirst = [...crops]..sort((first, second) => second.height.compareTo(first.height));
  final placements = <_Placement>[];
  var (shelfX, shelfY, shelfHeight) = (0, 0, 0);

  for (final crop in tallestFirst) {
    if (shelfX + crop.width > _shelfWidth) {
      shelfY += shelfHeight;
      (shelfX, shelfHeight) = (0, 0);
    }

    placements.add((crop: crop, x: shelfX, y: shelfY));
    shelfX += crop.width;
    if (crop.height > shelfHeight) shelfHeight = crop.height;
  }

  return placements;
}

Future<void> _writePackedImage(Image atlas, List<_Placement> placements, {required String to}) async {
  final width = placements
      .map((placement) => placement.x + placement.crop.width)
      .reduce((first, second) => first > second ? first : second);
  final height = placements
      .map((placement) => placement.y + placement.crop.height)
      .reduce((first, second) => first > second ? first : second);
  final packed = Image(width: width, height: height, numChannels: 4);

  for (final (:crop, :x, :y) in placements) {
    final frame = copyCrop(
      atlas,
      x: crop.column * _cellWidth + crop.x,
      y: crop.row * _cellHeight + crop.y,
      width: crop.width,
      height: crop.height,
    );

    compositeImage(packed, frame, dstX: x, dstY: y, blend: BlendMode.direct);
  }

  final temporaryDirectory = Directory.systemTemp.createTempSync('unit_atlas');
  final packedPng = File('${temporaryDirectory.path}/atlas.png')..writeAsBytesSync(encodePng(packed));
  final encoding = await Process.run('cwebp', ['-lossless', '-z', '9', '-quiet', packedPng.path, '-o', to]);
  temporaryDirectory.deleteSync(recursive: true);

  if (encoding.exitCode != 0) throw ProcessException('cwebp', [packedPng.path], '${encoding.stderr}', encoding.exitCode);
}

String _framesJsonOf(List<_Placement> placements) {
  final framesInAtlasOrder = [...placements]
    ..sort((first, second) {
      final rowOrder = first.crop.row.compareTo(second.crop.row);
      return rowOrder != 0 ? rowOrder : first.crop.column.compareTo(second.crop.column);
    });

  return const JsonEncoder.withIndent('  ').convert({
    'frames': [
      for (final (:crop, :x, :y) in framesInAtlasOrder)
        {
          'row': crop.row,
          'column': crop.column,
          'x': x,
          'y': y,
          'width': crop.width,
          'height': crop.height,
          'offsetX': crop.x - _anchorX,
          'offsetY': crop.y - _anchorY,
        },
    ],
  });
}
