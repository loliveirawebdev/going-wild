import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/design_system_catalog/design_system_catalog_app.dart';

void main() {
  configurePluralResolvers();
  runApp(const DesignSystemCatalogApp());
}
