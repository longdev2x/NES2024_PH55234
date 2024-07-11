    import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<String> listCategory = ['Tất cả', 'Thể chất', 'Tinh thần', 'Ngủ nghỉ', 'Ăn uống', 'Thiền và Yoga', 'Tư vấn bí mật'];
final homeHoriCategoryProvider = StateProvider.autoDispose<String>((ref) => listCategory[0]);