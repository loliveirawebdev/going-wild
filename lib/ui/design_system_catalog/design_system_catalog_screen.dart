import 'package:flutter/material.dart';
import 'package:going_wild/ui/design_system_catalog/design_system_catalog_section.dart';
import 'package:going_wild/ui/design_system_catalog/design_system_catalog_sections.dart';

class DesignSystemCatalogScreen extends StatelessWidget {
  const DesignSystemCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design system')),
      body: ListView(
        children: [
          for (final section in designSystemCatalogSections)
            ListTile(
              title: Text(section.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => _SectionPage(section: section))),
            ),
        ],
      ),
    );
  }
}

class _SectionPage extends StatelessWidget {
  const _SectionPage({required this.section});
  final DesignSystemCatalogSection section;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(section.title)),
      body: section.builder(context),
    );
  }
}
