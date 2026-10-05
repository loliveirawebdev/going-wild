import 'package:flutter/widgets.dart';

class UnitSale {
  const UnitSale({required this.onSell, required this.valueInCoins, this.disabledReason});

  final int valueInCoins;
  final String? disabledReason;
  final VoidCallback? onSell;
}
