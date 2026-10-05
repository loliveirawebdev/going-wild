import 'package:flutter/widgets.dart';

const _sixtyPercentAlphaRow = <double>[0, 0, 0, 0.6, 0];
const _thirtyFivePercentAlphaRow = <double>[0, 0, 0, 0.35, 0];
const _luminanceRow = <double>[0.2126, 0.7152, 0.0722, 0, 0];

abstract final class AppColorFilters {
  static const disabledIcon = ColorFilter.matrix([
    ..._luminanceRow,
    ..._luminanceRow,
    ..._luminanceRow,
    ..._sixtyPercentAlphaRow,
  ]);

  static const lostIcon = ColorFilter.matrix([
    ..._luminanceRow,
    ..._luminanceRow,
    ..._luminanceRow,
    ..._thirtyFivePercentAlphaRow,
  ]);
}
