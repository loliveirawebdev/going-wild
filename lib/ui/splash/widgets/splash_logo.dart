import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/brand_logo.dart';

const _maxLogoWidth = 320.0;
const _logoWidthFraction = 0.78;
const _logoTopFraction = 0.14;
const _fadeDuration = Duration(milliseconds: 260);

class SplashLogo extends StatelessWidget {
  final bool isVisible;
  const SplashLogo({required this.isVisible, super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final logoWidth = (screenSize.width * _logoWidthFraction).clamp(0.0, _maxLogoWidth);

    return Positioned(
      left: 0,
      right: 0,
      top: screenSize.height * _logoTopFraction,
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: _fadeDuration,
          opacity: isVisible ? 1 : 0,
          child: Center(
            child: Semantics(
              header: true,
              label: context.t.app.title,
              child: Image.asset(BrandLogo.assetPath, width: logoWidth, excludeFromSemantics: true),
            ),
          ),
        ),
      ),
    );
  }
}
