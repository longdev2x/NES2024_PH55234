import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/features/grateful/controller/grateful_provider.dart';
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
          appBar: appGlobalAppBar('Nhật ký biết ơn', actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutesNames.search);
                },
                icon: const Icon(Icons.search)),
          ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.marginHori),
              child: fetchList.when(
                  data: (listPost) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        listPost.isEmpty
                            ? const SizedBox()
                            : ListView.builder(
                                itemCount: listPost.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  PostGratefulEntity objPost = listPost[index];
                                  return GratefulPostItem(objPost: objPost);
                                },
                              )
                      ],
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
                  color: Colors.orange.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
              onPressed: () => showModalBottomSheet(
                context: context,
                useSafeArea: false,
                enableDrag: false,
                isScrollControlled: true,
                builder: (ctx) => const PostBottomScreen(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
