import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/features/grateful/controller/grateful_provider.dart';
import 'package:nes24_ph55234/features/grateful/controller/post_grateful_provider.dart';
import 'package:nes24_ph55234/features/grateful/view/grateful_items.dart';
import 'package:nes24_ph55234/features/grateful/view/post_bottom_screen.dart';

class GratefulScreen extends ConsumerWidget {
  const GratefulScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchList = ref.watch(gratefulProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: appGlobalAppBar('Nhật ký biết ơn'),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.marginHori),
              child: fetchList.when(
                  data: (listPost) {
                    return listPost.isEmpty
                        ? Padding(
                          padding: EdgeInsets.only(top: 300.h),
                          child: const Center(child: AppText18('Chưa có bài viết nào')),
                        )
                        : ListView.builder(
                            itemCount: listPost.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              PostGratefulEntity objPost = listPost[index];
                              return Dismissible(
                                  key: ValueKey(objPost.id),
                                  confirmDismiss: (direction) async {
                                    bool? result = await showDialog(
                                      context: context,
                                      builder: (ctx) => AppConfirm(
                                        title: 'Bạn muốn xoá chứ?',
                                        onNoConfirm: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        onConfirm: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    );
                                    return result;
                                  },
                                  background:
                                      const BackgrounDismissiableWidget(),
                                  onDismissed: (direction) {
                                    ref
                                        .read(gratefulProvider.notifier)
                                        .deletePost(objPost.id);
                                  },
                                  child: GratefulPostItem(objPost: objPost));
                            },
                          );
                  },
                  error: (error, stackTrace) =>
                      const Center(child: AppText40('Error')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator())),
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          right: 20.w,
          bottom: 20.h,
          child: Container(
            height: 56.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.2), // Giảm độ mờ
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.edit, size: 24),
              label: Text(
                'Viết biết ơn',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              onPressed: () {
                ref.read(createPostGratefulProvider.notifier).reset();
                showModalBottomSheet(
                  context: context,
                  useSafeArea: false,
                  enableDrag: false,
                  isScrollControlled: true,
                  builder: (ctx) => const PostBottomScreen(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class BackgrounDismissiableWidget extends StatelessWidget {
  const BackgrounDismissiableWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 216, 22, 8),
            borderRadius: BorderRadius.circular(20)),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 100.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, color: Colors.white, size: 50.w),
                SizedBox(height: 7.h),
                Text(
                  'Xóa',
                  style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
