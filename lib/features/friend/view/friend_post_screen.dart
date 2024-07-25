import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/friend/view/friend_create_post_screen.dart';
import 'package:nes24_ph55234/features/friend/view/friend_widgets.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';

class FriendPostScreen extends ConsumerWidget {
  const FriendPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchUser = ref.watch(profileProvider);
    return Scaffold(
      body: Column(
        children: [
          fetchUser.when(
              data: (objUser) => FPostHeaderWidget(
                    avatar: objUser.avatar,
                    onTapRow: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: false,
                        enableDrag: false,
                        isScrollControlled: true,
                        builder: (ctx) => FriendCreatePostScreen(objUser: objUser),
                      );
                    },
                    onTapImagePicker: () {
                      _addImage(context, objUser);
                    },
                  ),
              error: (error, stackTrace) => const Center(child: Text('Error')),
              loading: () => FPostHeaderWidget(
                    avatar: null,
                    onTapImagePicker: () {},
                    onTapRow: () {},
                  )),
          // FpostContent();
        ],
      ),
    );
  }

  void _addImage(BuildContext context, UserEntity objUser) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if(!context.mounted) return;

    showModalBottomSheet(
      context: context,
      useSafeArea: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (ctx) => FriendCreatePostScreen(
        initImages: images,
        objUser: objUser,
      ),
    );
  }
}
