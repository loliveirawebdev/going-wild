import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

typedef TapOf = VoidCallback Function(String label);

class CatalogTapLog extends StatefulWidget {
  const CatalogTapLog({required this.builder, super.key});

  final Widget Function(BuildContext context, TapOf tapOf) builder;

  @override
  State<CatalogTapLog> createState() => _CatalogTapLogState();
}

class _CatalogTapLogState extends State<CatalogTapLog> {
  var _tapCount = 0;
  String? _lastTappedLabel;

  VoidCallback _tapOf(String label) =>
      () => setState(() {
        _tapCount++;
        _lastTappedLabel = label;
      });

  @override
  Widget build(BuildContext context) {
    final lastTappedLabel = _lastTappedLabel;
    final tapWord = _tapCount == 1 ? 'toque' : 'toques';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.surface200,
          padding: const EdgeInsets.all(AppSpacing.space3),
          child: Text(
            lastTappedLabel == null ? 'Toque num botão' : 'Tocou em $lastTappedLabel · $_tapCount $tapWord',
            style: AppTextStyles.bodyStrong,
          ),
        ),
        Expanded(child: widget.builder(context, _tapOf)),
      ],
    );
  }
}
