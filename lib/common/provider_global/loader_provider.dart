import 'package:flutter_riverpod/flutter_riverpod.dart';

final loaderProvider = StateProvider.autoDispose<bool>((ref) => false);
