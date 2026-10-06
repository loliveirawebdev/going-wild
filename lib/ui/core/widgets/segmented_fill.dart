import 'package:flutter/widgets.dart';

const _resolution = 1000;

typedef FillSegment = ({double fraction, Color color});

class SegmentedFill extends StatelessWidget {
  const SegmentedFill({required this.segments, super.key});

  final List<FillSegment> segments;

  @override
  Widget build(BuildContext context) {
    final flexes = [for (final segment in segments) (flex: (segment.fraction.clamp(0.0, 1.0) * _resolution).round(), color: segment.color)];
    final emptyFlex = _resolution - flexes.fold<int>(0, (sum, segment) => sum + segment.flex);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final segment in flexes)
          if (segment.flex > 0)
            Expanded(
              flex: segment.flex,
              child: ColoredBox(color: segment.color),
            ),
        if (emptyFlex > 0) Spacer(flex: emptyFlex),
      ],
    );
  }
}
