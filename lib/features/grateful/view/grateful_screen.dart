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
                        Container(
                          decoration: const BoxDecoration(color: Colors.amber),
                          child: const AppText34(
                            'Phần mục tiêu',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        listPost.isEmpty
                            ? const SizedBox()
                            : ListView.builder(
                                itemCount: listPost.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  PostEntity objPost = listPost[index];
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
          left: 150.w,
          right: 150.w,
          bottom: 20.h,
          child: FloatingActionButton(
            child: const Text('POST'),
            onPressed: () => showModalBottomSheet(
              context: context,
              useSafeArea: false,
              isScrollControlled: true,
              builder: (ctx) => const PostBottomScreen(),
            ),
          ),
        ),
      ],
    );
  }
}
