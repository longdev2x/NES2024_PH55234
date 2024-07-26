import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/friend/controller/create_post_friend_provider.dart';
import 'package:nes24_ph55234/features/friend/controller/friend_post_provider.dart';

class FriendCreatePostScreen extends ConsumerStatefulWidget {
  final UserEntity objUser;
  const FriendCreatePostScreen({
    super.key,
    required this.objUser,
  });

  @override
  ConsumerState<FriendCreatePostScreen> createState() =>
      _FriendCreatePostScreenState();
}

class _FriendCreatePostScreenState
    extends ConsumerState<FriendCreatePostScreen> {
  late final UserEntity objUser;
  late PostFriendEntity objPost;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    objUser = widget.objUser;
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final objPost = ref.watch(friendCreatePostProvider(objUser));
    final FriendCreatePostNotifier notifier =
        ref.read(friendCreatePostProvider(objUser).notifier);
    List<File?> imageFiles = objPost.imageFiles;

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
                    _saveLocalProvider(_controller, notifier);
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
              _saveLocalProvider(_controller, notifier);
              _post(objUser, notifier, _controller);
              ref.read(friendCreatePostProvider(objUser).notifier).reset();
              Navigator.pop(context);
            },
            child: const AppText20('Đăng'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.marginHori),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: objUser.avatar != null
                            ? NetworkImage(objUser.avatar!)
                            : const AssetImage(ImageRes.avatarDefault)
                                as ImageProvider,
                        radius: 35,
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.h),
                          AppText20(
                            objUser.username,
                            fontWeight: FontWeight.bold,
                          ),
                          DropdownButton<PostLimit>(
                            value: objPost.limit,
                            items: const [
                              DropdownMenuItem<PostLimit>(
                                  value: PostLimit.public,
                                  child: Text('Công khai')),
                              DropdownMenuItem<PostLimit>(
                                  value: PostLimit.private,
                                  child: Text('Chỉ mình tôi')),
                            ],
                            onChanged: (value) {
                              notifier.updateState(
                                  limit: PostLimit.values
                                      .firstWhere((e) => e == value));
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) =>
                                _emojiDialog(ctx, notifier: notifier),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: AppImage(
                            imagePath: emoijMap[objPost.feel],
                            height: 45,
                            width: 45,
                            boxFit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  AppTextFieldNoborder(
                    controller: _controller,
                    hintText: 'Hãy nói gì đó về nội dung này...',
                    fontSize: 18.sp,
                    maxLines: 10,
                    width: double.infinity,
                    inputType: TextInputType.multiline,
                    paddingContent: EdgeInsets.only(
                      left: 0,
                      top: 10.h,
                      bottom: 10.h,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  //Hàng ảnh
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //min giữa 3 và length, tránh trường hợp nhỏ hơn 3, chỉ lấy tối đa 3 ảnh
                      ...List.generate(
                        min(3, imageFiles.length),
                        (index) {
                          if (imageFiles[index] == null) {
                            return const SizedBox();
                          }
                          return index == 2 && imageFiles.length > 3
                              ? Stack(
                                  children: [
                                    Image.file(
                                      imageFiles[index]!,
                                      fit: BoxFit.cover,
                                      height: 70.h,
                                      width: 96.w,
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        height: 70.h,
                                        width: 96.w,
                                        color: Colors.black.withOpacity(0.5),
                                        child: Center(
                                          child: AppText20(
                                            '+${imageFiles.length - 3}',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Image.file(
                                  imageFiles[index]!,
                                  fit: BoxFit.cover,
                                  height: 70.h,
                                  width: 96.w,
                                );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      for (var image in images) {
        File file = File(image.path);
        ref.read(friendCreatePostProvider(objUser).notifier).addImage(file);
      }
    }
  }

  void _post(UserEntity objUser, FriendCreatePostNotifier notifier,
      TextEditingController controller) {
    _saveLocalProvider(controller, notifier);
    final PostFriendEntity objPost =
        ref.read(friendCreatePostProvider(objUser));
    ref.read(friendPostProvider.notifier).createOrUpdatePost(objPost);
  }

  void _saveLocalProvider(
    TextEditingController controller,
    FriendCreatePostNotifier notifier,
  ) {
    notifier.updateState(content: controller.text);
  }
}
