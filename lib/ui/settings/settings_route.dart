import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import 'widgets/settings_screen.dart';

final settingsRoute = GoRoute(
  path: Routes.settings,
  builder: (context, state) => const SettingsScreen(),
);
