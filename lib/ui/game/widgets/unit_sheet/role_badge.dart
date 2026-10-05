import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/role_icon.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_badge.dart';

const _iconSize = 20.0;

class RoleBadge extends StatelessWidget {
  const RoleBadge({required this.role, super.key});

  final Role role;

  @override
  Widget build(BuildContext context) {
    return UnitBadge(
      label: context.t['game.unitSheet.roles.${role.name}'] as String? ?? role.name,
      icon: SvgPicture.asset(roleIconAssetPathOf(role), width: _iconSize, height: _iconSize),
    );
  }
}
