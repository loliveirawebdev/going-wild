import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/settings/widgets/text_page.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = context.t.credits;

    return TextPage(
      title: translations.title,
      sections: [TextPageSection(paragraphs: translations.paragraphs)],
    );
  }
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = context.t.privacy;

    return TextPage(
      title: translations.title,
      intro: translations.intro,
      updated: translations.updated,
      sections: [
        TextPageSection(title: translations.whatWeStore.title, paragraphs: translations.whatWeStore.paragraphs),
        TextPageSection(title: translations.whatWeShare.title, paragraphs: translations.whatWeShare.paragraphs),
        TextPageSection(title: translations.deletingYourData.title, paragraphs: translations.deletingYourData.paragraphs),
        TextPageSection(title: translations.contact.title, paragraphs: translations.contact.paragraphs),
      ],
    );
  }
}

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = context.t.terms;

    return TextPage(
      title: translations.title,
      intro: translations.intro,
      updated: translations.updated,
      sections: [
        TextPageSection(title: translations.gameUse.title, paragraphs: translations.gameUse.paragraphs),
        TextPageSection(title: translations.content.title, paragraphs: translations.content.paragraphs),
        TextPageSection(title: translations.noWarranty.title, paragraphs: translations.noWarranty.paragraphs),
        TextPageSection(title: translations.changes.title, paragraphs: translations.changes.paragraphs),
      ],
    );
  }
}
