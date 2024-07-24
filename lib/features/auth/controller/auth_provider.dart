import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';

final isLoginProvider = StateProvider.autoDispose<bool>((ref) => true);

final isRememberProvider = StateProvider.autoDispose<bool?>((ref) => false);

final roleProvider = StateProvider.autoDispose<Role?>((ref) => listRoles[0]);