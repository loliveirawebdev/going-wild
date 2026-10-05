import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/ui/core/design/set_icon.dart';

class SetIconImage extends StatelessWidget {
  final SetId setId;
  final double size;
  const SetIconImage(this.setId, {super.key, this.size = 34});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(setIconAssetPathOf(setId), width: size, height: size);
}
