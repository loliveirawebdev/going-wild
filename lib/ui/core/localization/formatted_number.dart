import 'package:going_wild/generated/i18n/translations.g.dart';

String formattedNumberOf(Translations translations, double number) {
  if (number == number.roundToDouble()) return '${number.round()}';
  return number.toStringAsFixed(1).replaceAll('.', translations.app.decimalSeparator);
}
