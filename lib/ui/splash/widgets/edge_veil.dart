import 'package:flutter/widgets.dart';

const _veil = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0, 0.16, 0.72, 1],
  colors: [Color(0x4D6B3E1F), Color(0x006B3E1F), Color(0x006B3E1F), Color(0x476B3E1F)],
);

class EdgeVeil extends StatelessWidget {
  const EdgeVeil({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(decoration: BoxDecoration(gradient: _veil)),
    );
  }
}
