import 'package:flutter/animation.dart';

double easedPingPongOf(double cycleProgress) {
  final pingPong = cycleProgress < 0.5 ? cycleProgress * 2 : (1 - cycleProgress) * 2;
  return Curves.easeInOut.transform(pingPong);
}
