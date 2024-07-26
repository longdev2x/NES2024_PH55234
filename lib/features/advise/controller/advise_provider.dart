import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/advise_entity.dart';
import 'package:nes24_ph55234/data/repositories/advise_repos.dart';
import 'package:nes24_ph55234/global.dart';

//Màn hình list cuộc trò chuyện
final adviseSessionsProvider = StreamProvider.autoDispose<List<AdviseSession>>((ref) {
  final String userId = Global.storageService.getUserId();
  final String userRole = Global.storageService.getRole();

  if (userRole == AppConstants.roleExpert) {
    return AdviseRepos.getAllAdviseSessions();
  } else {
    return AdviseRepos.getUserAdviseSessions(userId);
  }
});

//Phần tin nhắn chi tiết, AdviseSession chứa list<messages>
final adviseSessionDetailProvider = StreamProvider.family<AdviseSession, String>((ref, sessionId) {
  return AdviseRepos.getAdviseSessionStream(sessionId);
});

