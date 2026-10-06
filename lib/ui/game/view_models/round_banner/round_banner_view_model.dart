import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/ui/game/view_models/round_banner/round_banner.dart';

class RoundBannerViewModel extends Cubit<RoundBanner?> {
  RoundBannerViewModel() : super(null);

  void startCountdown() => emit(const CountdownRoundBanner());
  void showResult(ResultRoundBanner resultBanner) => emit(resultBanner);
  void dismiss() => emit(null);
}
