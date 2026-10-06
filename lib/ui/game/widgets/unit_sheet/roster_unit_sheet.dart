import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_copy_from_roster_slot.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_sold_from_roster_slot.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sale.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

Future<void> presentRosterUnitSheet(
  BuildContext context, {
  required RosterSlot rosterSlot,
  required MatchProgress matchProgress,
  required CharacterCopy characterCopy,
  Stats? stats,
}) {
  final preparationBloc = context.read<PreparationBloc>();
  final engines = matchProgress.phase.engines;
  final rejection = checkSellingCopyFromRosterSlot(matchProgress, from: rosterSlot);

  return presentUnitSheet(
    context,
    stats: stats,
    engines: engines,
    side: UnitSide.team,
    characterCopy: characterCopy,
    sale: UnitSale(
      valueInCoins: engines.economyEngine.sellPriceOf(characterCopy, matchProgress: matchProgress),
      disabledReason: rejection == null ? null : rejectionMessageOf(context.t, rejection),
      onSell: rejection == null ? () => preparationBloc.add(CopySoldFromRosterSlot(from: rosterSlot)) : null,
    ),
  );
}
