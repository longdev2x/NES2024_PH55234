import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomTabsProvider = StateProvider.autoDispose<int>((ref) => 0);

final drawerIndexProvider = StateProvider.autoDispose<int?>((ref) => null);

final drawerClosedProvider = StateProvider.autoDispose<bool>((ref) => true);

