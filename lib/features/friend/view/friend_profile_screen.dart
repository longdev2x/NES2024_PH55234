import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/features/friend/controller/friend_provider.dart';
import 'package:nes24_ph55234/features/friend/view/friend_widgets.dart';
import 'package:nes24_ph55234/features/profile/view/profile/profile_widgets.dart';

class FriendProfileScreen extends ConsumerStatefulWidget {
  const FriendProfileScreen({super.key});

  @override
  ConsumerState<FriendProfileScreen> createState() =>
      _FriendProfileScreenState();
}

class _FriendProfileScreenState extends ConsumerState<FriendProfileScreen> {
  late FriendEntity objFriend;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    objFriend = ModalRoute.of(context)!.settings.arguments as FriendEntity;
  }

  @override
  Widget build(BuildContext context) {
    final fetchFriend = ref.watch(friendProfileProvider(objFriend.username));
    return Scaffold(
      appBar: AppBar(),
      body: fetchFriend.when(
        data: (objFriends) {
          if (objFriends.isEmpty) {
            return const Center(
              child: Text('Không tìm thấy thông tin bạn bè'),
            );
          }
          return _buildContent(objFriends[0], context);
        },
        error: (error, stackTrace) => Center(
          child: Text('Lỗi lấy info bạn - $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildContent(FriendEntity objFriend, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30.h),
            ProfileAvatarWidget(
              avatar: objFriend.avatar,
              isMyProfile: false,
            ),
            SizedBox(height: 20.h),
            AppText20('${objFriend.username} (${objFriend.role?.name})',
                fontWeight: FontWeight.bold),
            SizedBox(height: 40.h),
            const Align(
              alignment: Alignment.topLeft,
              child: AppText24('Bài viết'),
            ),
            SizedBox(height: 20.h),
            FpostContent(friendId: objFriend.friendId)
          ],
        ),
      ),
    );
  }
}
