import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomTabsProvider = StateProvider.autoDispose<int>((ref) => 0);