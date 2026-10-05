import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/interface_glyph_image.dart';

const _rowMinimumHeight = 56.0;
const _chevronSize = 20.0;

const _labelStyle = TextStyle(
  fontSize: 15,
  height: 21 / 15,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

const _hintStyle = TextStyle(
  fontSize: 13,
  height: 18 / 13,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w600,
);

class SettingsRow extends StatelessWidget {
  const SettingsRow({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _rowMinimumHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3, horizontal: AppSpacing.space4),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }
}

class SettingsLabelRow extends StatelessWidget {
  const SettingsLabelRow({required this.label, required this.trailing, super.key, this.hint});

  final String label;
  final String? hint;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final hint = this.hint;

    return SettingsRow(
      child: Row(
        spacing: AppSpacing.space3,
        children: [
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _labelStyle),
                if (hint != null) Text(hint, style: _hintStyle),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class SettingsLinkRow extends StatefulWidget {
  const SettingsLinkRow({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  State<SettingsLinkRow> createState() => _SettingsLinkRowState();
}

class _SettingsLinkRowState extends State<SettingsLinkRow> {
  var _isPressed = false;

  void _setPressed(bool isPressed) => setState(() => _isPressed = isPressed);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      container: true,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: ColoredBox(
          color: _isPressed ? AppColors.surface200 : AppColors.surface100,
          child: SettingsLabelRow(
            label: widget.label,
            trailing: const InterfaceGlyphImage(InterfaceGlyph.next, size: _chevronSize, color: AppColors.inkMuted),
          ),
        ),
      ),
    );
  }
}
