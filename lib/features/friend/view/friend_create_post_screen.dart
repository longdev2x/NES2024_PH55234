import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/friend/controller/create_post_friend_provider.dart';
import 'package:nes24_ph55234/features/friend/controller/friend_post_provider.dart';

class FriendCreatePostScreen extends ConsumerStatefulWidget {
  final UserEntity objUser;
  final List<XFile>? initImages;
  const FriendCreatePostScreen({
    super.key,
    this.initImages,
    required this.objUser,
  });

  @override
  ConsumerState<FriendCreatePostScreen> createState() =>
      _FriendCreatePostScreenState();
}

class _FriendCreatePostScreenState
    extends ConsumerState<FriendCreatePostScreen> {
  // final ImagePicker _picker = ImagePicker();
  late final UserEntity objUser;
  late PostFriendEntity objPost;
  @override
  void initState() {
    super.initState();
    objUser = widget.objUser;
    objPost = ref.read(friendCreatePostProvider(objUser));
  }

  @override
  Widget build(BuildContext context) {
    objPost = ref.watch(friendCreatePostProvider(objUser));
    final FriendCreatePostNotifier notifier =
        ref.read(friendCreatePostProvider(objUser).notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 120.h,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AppConfirm(
                  title: 'Dữ liệu sẽ không được lưu, bạn chắc chứ?',
                  onConfirm: () {
                    _saveLocalProvider();
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  }),
            );
          },
          icon: const Icon(Icons.close),
        ),
        title: const AppText20(
          'Tạo bài viết',
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              _saveLocalProvider();
              _post(objUser);
              ref.read(friendCreatePostProvider(objUser).notifier).reset();
              Navigator.pop(context);
            },
            child: const AppText20('Đăng'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: objUser.avatar != null
                          ? NetworkImage(objUser.avatar!)
                          : const AssetImage(ImageRes.avatarDefault)
                              as ImageProvider,
                      radius: 25,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText16(
                            objUser.username,
                            fontWeight: FontWeight.bold,
                          ),
                          // DropdownButton<String>(
                          //   value: ,
                          //   items: items,
                          //   onChanged: onChanged,
                          // ),
                          // AppText14(
                          //   'Vai trò: ${objFriendShip.role.name}',
                          // ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) =>
                              _emojiDialog(ctx, notifier: notifier),
                        );
                      },
                      child: AppImage(
                        imagePath: emoijMap[objPost.feel],
                        height: 60,
                        width: 60,
                        boxFit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          left: 10.w,
          right: 10.w,
        ),
        child: Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _addImage,
                icon: const AppIcon(path: ImageRes.icAddImage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(dynamic item) {
    if (item is File) {
      return Image.file(
        item,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      );
    } else if (item is String) {
      return Image.network(
        item,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      );
    }
    return const SizedBox();
  }

  Widget _emojiDialog(BuildContext context,
          {required FriendCreatePostNotifier notifier}) =>
      Dialog(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppText16(
                'Ngày hôm nay của bạn thế nào?',
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 150.h,
                width: 300.w,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h),
                    itemCount: PostFeel.values.length,
                    itemBuilder: (ctx, index) {
                      return AppImage(
                          onTap: () {
                            notifier.updateState(feel: PostFeel.values[index]);
                            Navigator.pop(context);
                          },
                          imagePath: emoijMap[PostFeel.values[index]]);
                    }),
              ),
            ],
          ),
        ),
      );

  void _addImage() async {
    // final List<XFile> images = await _picker.pickMultiImage();
  }

  void _saveLocalProvider() {}

  void _post(UserEntity objUser) {
    _saveLocalProvider();
    final PostFriendEntity objPost = ref.read(friendCreatePostProvider(objUser));
    ref.read(friendPostProvider.notifier).createOrUpdatePost(objPost);
  }
}
