import 'package:go_router/go_router.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/settings/widgets/settings_screen.dart';

final settingsRoute = GoRoute(
  path: Routes.settings,
  builder: (context, state) => const SettingsScreen(),
);
