part of 'phase_event.dart';

class ShopOffersRefreshed extends PhaseEvent {
  const ShopOffersRefreshed({required super.roundNumber, required this.shopOffers});

  final List<Character?> shopOffers;
}
