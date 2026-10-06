import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/ui/core/design/brand_logo.dart';
import 'package:going_wild/ui/core/design/combat_effect_icon.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/design/painted_scene.dart';
import 'package:going_wild/ui/core/design/role_icon.dart';
import 'package:going_wild/ui/core/design/set_icon.dart';
import 'package:going_wild/ui/entrypoint/view_models/entrypoint_view_model.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';
import 'package:going_wild/ui/settings/view_models/settings_view_model.dart';

const _simulatedLoadingDurationInDebug = Duration(milliseconds: 2500);

List<LoadingStep> splashLoadingStepsOf(BuildContext context) {
  final loadingSteps = <LoadingStep>[
    () => context.read<SettingsViewModel>().load(),
    () => context.read<PhaseProgressViewModel>().load(),
    () => precacheImage(AssetImage(PaintedScene.splash.assetPath), context),
    () => precacheImage(const AssetImage(BrandLogo.assetPath), context),
    for (final icon in GameIcon.values) () => SvgAssetLoader(icon.assetPath).loadBytes(null),
    for (final glyph in InterfaceGlyph.values) () => SvgAssetLoader(glyph.assetPath).loadBytes(null),
    for (final set in allSets) () => SvgAssetLoader(setIconAssetPathOf(set.id)).loadBytes(null),
    for (final role in Role.values) () => SvgAssetLoader(roleIconAssetPathOf(role)).loadBytes(null),
    for (final effectIcon in CombatEffectIcon.values) () => SvgAssetLoader(effectIcon.assetPath).loadBytes(null),
  ];

  if (!kDebugMode) return loadingSteps;

  final minimumStepDuration = _simulatedLoadingDurationInDebug ~/ loadingSteps.length;

  return [
    for (final loadingStep in loadingSteps) () => Future.wait([loadingStep(), Future<void>.delayed(minimumStepDuration)]),
  ];
}
