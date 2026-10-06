import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';

const minimumBoardZoom = 1.0;
const maximumBoardZoom = 2.0;
const _fieldClearance = 72.0;

typedef BoardFraming = ({double sceneTop, double contentHeight, double scrolledDistance});

double get _fieldBottomInImage => BoardSceneLayout.rowCenterHeights.last + BoardSceneLayout.cellSize.height / 2;

BoardFraming boardFramingOf({required Size viewportSize, required double fieldBottomLimit}) {
  final fieldBottom = _fieldBottomInImage * BoardSceneLayout.scaleFor(viewportSize.width);
  final freeSpace = fieldBottomLimit - _fieldClearance - fieldBottom;
  final overflow = max(-freeSpace, 0.0);

  return (sceneTop: max(freeSpace, 0.0), contentHeight: viewportSize.height + overflow, scrolledDistance: overflow);
}

Matrix4 transformOf(BoardFraming framing) => Matrix4.translationValues(0, -framing.scrolledDistance, 0);
