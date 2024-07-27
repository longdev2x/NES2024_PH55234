import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/advise_entity.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/data/repositories/advise_repos.dart';
import 'package:nes24_ph55234/global.dart';

//Màn hình list cuộc trò chuyện
final adviseSessionsProvider =
    StreamProvider.autoDispose<List<AdviseSession>>((ref) {
  final String userId = Global.storageService.getUserId();
  final String role = Global.storageService.getRole();

  if (role == listRoles[0].name) {
    return AdviseRepos.getUserAdviseSessions(userId);
  } else {
    return AdviseRepos.getAllAdviseSessions();
  }
});

//Phần tin nhắn chi tiết, AdviseSession chứa list<messages>
final adviseSessionDetailProvider =
    StreamProvider.family<AdviseSession, String>((ref, sessionId) {
  return AdviseRepos.getAdviseSessionStream(sessionId);
});
