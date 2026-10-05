import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _minimumValue = 0;
const _maximumValue = 100;
const _trackHeight = 16.0;
const _touchAreaHeight = 32.0;
const _thumbDiameter = 30.0;
const _thumbShadowHeight = 3.0;
const _draggingThumbScale = 1.08;
const _valueMinimumWidth = 44.0;
const _thumbScaleDuration = Duration(milliseconds: 100);

const _labelStyle = TextStyle(
  fontSize: 15,
  height: 21 / 15,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

const _valueStyle = TextStyle(
  fontSize: 17,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class Slider extends StatefulWidget {
  const Slider({required this.label, required this.value, required this.onChanged, required this.valueLabelOf, super.key});

  final int value;
  final String label;
  final ValueChanged<int> onChanged;
  final String Function(int value) valueLabelOf;

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  var _isDragging = false;

  void _changeValueAt(double horizontalPosition, double trackWidth) {
    final travel = trackWidth - _thumbDiameter;
    final fraction = ((horizontalPosition - _thumbDiameter / 2) / travel).clamp(0.0, 1.0);
    final value = (_minimumValue + fraction * (_maximumValue - _minimumValue)).round();

    if (value != widget.value) widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = widget.value == _minimumValue;

    return Column(
      spacing: AppSpacing.space2,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: AppSpacing.space2,
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Expanded(child: Text(widget.label, style: _labelStyle)),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: _valueMinimumWidth),
              child: Text(
                widget.valueLabelOf(widget.value),
                textAlign: TextAlign.right,
                style: isMuted ? _valueStyle.copyWith(color: AppColors.inkMuted) : _valueStyle,
              ),
            ),
          ],
        ),
        Semantics(
          slider: true,
          label: widget.label,
          value: widget.valueLabelOf(widget.value),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;
              final fraction = (widget.value - _minimumValue) / (_maximumValue - _minimumValue);
              final thumbCenter = _thumbDiameter / 2 + fraction * (trackWidth - _thumbDiameter);

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => _changeValueAt(details.localPosition.dx, trackWidth),
                onHorizontalDragEnd: (_) => setState(() => _isDragging = false),
                onHorizontalDragCancel: () => setState(() => _isDragging = false),
                onHorizontalDragStart: (details) {
                  setState(() => _isDragging = true);
                  _changeValueAt(details.localPosition.dx, trackWidth);
                },
                onHorizontalDragUpdate: (details) => _changeValueAt(details.localPosition.dx, trackWidth),
                child: SizedBox(
                  height: _touchAreaHeight,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    clipBehavior: Clip.none,
                    children: [
                      _Track(filledWidth: thumbCenter),
                      Positioned(
                        left: thumbCenter - _thumbDiameter / 2,
                        child: AnimatedScale(
                          duration: _thumbScaleDuration,
                          scale: _isDragging ? _draggingThumbScale : 1,
                          child: const _Thumb(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Track extends StatelessWidget {
  const _Track({required this.filledWidth});

  final double filledWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _trackHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface300,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(width: filledWidth, color: AppColors.grass400),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _thumbDiameter,
      height: _thumbDiameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface100,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
        boxShadow: const [BoxShadow(color: AppColors.surface400, offset: Offset(0, _thumbShadowHeight))],
      ),
    );
  }
}
