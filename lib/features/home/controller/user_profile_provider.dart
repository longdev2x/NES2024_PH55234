import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/local/table_query/user_table.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';

final fetchUserProfileProvider = FutureProvider<UserEntity>((ref) async {
  return UserTable().getUser();
});