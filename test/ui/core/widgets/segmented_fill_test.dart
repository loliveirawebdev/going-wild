import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/core/widgets/segmented_fill.dart';

Future<void> showFill(WidgetTester tester, List<FillSegment> segments) => tester.pumpWidget(
  Directionality(
    textDirection: TextDirection.ltr,
    child: Center(
      child: SizedBox(width: 200, height: 6, child: SegmentedFill(segments: segments)),
    ),
  ),
);

void main() {
  testWidgets('a fill a hair short of full or barely started draws without breaking', (tester) async {
    await showFill(tester, [(fraction: 2474 / 2475, color: const Color(0xFF00FF00))]);
    expect(tester.takeException(), isNull);

    await showFill(tester, [(fraction: 1 / 2475, color: const Color(0xFF00FF00))]);
    expect(tester.takeException(), isNull);

    await showFill(tester, [
      (fraction: 0.9996, color: const Color(0xFF00FF00)),
      (fraction: 0.0004, color: const Color(0xFFFFFFFF)),
    ]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('each segment takes its share of the width', (tester) async {
    await showFill(tester, [
      (fraction: 0.5, color: const Color(0xFF00FF00)),
      (fraction: 0.25, color: const Color(0xFFFFFFFF)),
    ]);

    final boxes = tester.widgetList<ColoredBox>(find.byType(ColoredBox)).toList();
    expect(tester.getSize(find.byWidget(boxes[0])).width, 100);
    expect(tester.getSize(find.byWidget(boxes[1])).width, 50);
  });
}
