import 'package:go_router/go_router.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/settings/widgets/about_pages.dart';
import 'package:going_wild/ui/settings/widgets/settings_screen.dart';

final settingsRoute = GoRoute(
  path: Routes.settings,
  builder: (context, state) => const SettingsScreen(),
  routes: [
    GoRoute(path: 'credits', builder: (context, state) => const CreditsPage()),
    GoRoute(path: 'privacy', builder: (context, state) => const PrivacyPage()),
    GoRoute(path: 'terms', builder: (context, state) => const TermsPage()),
  ],
);
