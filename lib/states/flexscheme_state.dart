import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlexSchemeController extends StateNotifier<FlexScheme> {
  FlexSchemeController() : super(FlexScheme.material);

  void changeScheme(FlexScheme newScheme) {
    state = newScheme;
    state= state;
  }
}

final flexSchemeProvider =
    StateNotifierProvider<FlexSchemeController, FlexScheme>((ref) {
  return FlexSchemeController();
});
