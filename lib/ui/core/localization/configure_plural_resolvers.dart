import '../../../generated/i18n/translations.g.dart';

String portugueseCardinalResolver(num n, {String? zero, String? one, String? two, String? few, String? many, String? other}) {
  final isZeroOrOne = n.truncate() == 0 || n.truncate() == 1;
  return (isZeroOrOne ? one : null) ?? other!;
}

String portugueseOrdinalResolver(
  num n, {
  String? zero,
  String? one,
  String? two,
  String? few,
  String? many,
  String? other,
}) => other!;

void configurePluralResolvers() {
  LocaleSettings.setPluralResolverSync(
    locale: AppLocale.pt,
    cardinalResolver: portugueseCardinalResolver,
    ordinalResolver: portugueseOrdinalResolver,
  );
}
