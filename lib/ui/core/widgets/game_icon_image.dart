import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';

class GameIconImage extends StatelessWidget {
  final double size;
  final GameIcon icon;
  const GameIconImage(this.icon, {super.key, this.size = 24});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(icon.assetPath, width: size, height: size);
}
