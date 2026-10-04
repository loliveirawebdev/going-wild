import 'package:going_wild/ui/game/view_models/preparation/events/preparation_event.dart';

class ShopOfferBought extends PreparationEvent {
  const ShopOfferBought({required this.offerIndex});
  final int offerIndex;

  @override
  String toString() => 'ShopOfferBought(offerIndex: $offerIndex)';
}
