import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoaderStateNotifier extends StateNotifier<bool> {
  LoaderStateNotifier() : super(false);

  void updateLoader(bool loading) {
    state = loading;
  }
}

final loaderProvider = StateNotifierProvider<LoaderStateNotifier, bool>(
  (ref) => LoaderStateNotifier(),
);
