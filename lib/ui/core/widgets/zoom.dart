import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Zoom extends SingleChildRenderObjectWidget {
  const Zoom({required this.scale, required Widget super.child, super.key});

  final double scale;

  @override
  RenderZoom createRenderObject(BuildContext context) => RenderZoom(scale: scale);

  @override
  void updateRenderObject(BuildContext context, RenderZoom renderObject) => renderObject.scale = scale;
}

class RenderZoom extends RenderProxyBox {
  RenderZoom({required this._scale});

  double _scale;
  double get scale => _scale;

  set scale(double scale) {
    if (scale == _scale) return;
    _scale = scale;
    markNeedsLayout();
  }

  Matrix4 get _zoomTransform => Matrix4.diagonal3Values(scale, scale, 1);

  @override
  void performLayout() {
    final child = this.child!;
    child.layout(BoxConstraints(maxWidth: constraints.maxWidth / scale, maxHeight: constraints.maxHeight / scale), parentUsesSize: true);
    size = constraints.constrain(child.size * scale);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    layer = context.pushTransform(needsCompositing, offset, _zoomTransform, super.paint, oldLayer: layer as TransformLayer?);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintTransform(
      transform: _zoomTransform,
      position: position,
      hitTest: (result, position) => child!.hitTest(result, position: position),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) => transform.multiply(_zoomTransform);
}
