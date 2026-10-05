import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';

class InterfaceGlyphImage extends StatelessWidget {
  final double size;
  final Color? color;
  final InterfaceGlyph glyph;
  const InterfaceGlyphImage(this.glyph, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final currentColor = color ?? DefaultTextStyle.of(context).style.color ?? AppColors.ink;

    return SvgPicture.asset(
      glyph.assetPath,
      width: size,
      height: size,
      theme: SvgTheme(currentColor: currentColor),
    );
  }
}
