enum ShopCardState {
  sold,
  normal,
  locked,
  unaffordable;

  bool get isRaised => this == normal || this == unaffordable;
}
