import 'package:flutter/widgets.dart';

const _luminanceWeights = <double>[0.2126, 0.7152, 0.0722];

ColorFilter _desaturatedFilterOf({required double saturation, required double opacity}) {
  final desaturation = 1 - saturation;

  List<double> channelRowOf(int channelIndex) => [
    for (final (weightIndex, weight) in _luminanceWeights.indexed) weight * desaturation + (weightIndex == channelIndex ? saturation : 0),
    0,
    0,
  ];

  return ColorFilter.matrix([...channelRowOf(0), ...channelRowOf(1), ...channelRowOf(2), 0, 0, 0, opacity, 0]);
}

abstract final class AppColorFilters {
  static final disabledIcon = _desaturatedFilterOf(saturation: 0, opacity: 0.6);
  static final inactiveIcon = _desaturatedFilterOf(saturation: 0, opacity: 0.5);
  static final lostIcon = _desaturatedFilterOf(saturation: 0, opacity: 0.35);
  static final soldCard = _desaturatedFilterOf(saturation: 0, opacity: 0.35);
  static final lockedCard = _desaturatedFilterOf(saturation: 0.35, opacity: 0.7);
  static final fallenArt = _desaturatedFilterOf(saturation: 0, opacity: 1);
  static final none = _desaturatedFilterOf(saturation: 1, opacity: 1);
}
