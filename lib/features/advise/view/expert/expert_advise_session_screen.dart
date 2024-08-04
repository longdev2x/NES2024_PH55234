import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/advise_entity.dart';
import 'package:nes24_ph55234/features/advise/controller/advise_provider.dart';
import 'package:nes24_ph55234/features/advise/view/advise_chat_detail_screen.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';

class ExpertAdviseSessionScreen extends ConsumerWidget {
  const ExpertAdviseSessionScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchSessions = ref.watch(adviseSessionsProvider);
    final fetchUser = ref.watch(profileProvider);
    final List<String> listCategoryOfExpert = fetchUser.value!.category;

    List<AdviseSession> healthSessions = [];
    List<AdviseSession> lawSessions = [];
    List<AdviseSession> tamlySessions = [];

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách yêu cầu tư vấn')),
      body: fetchSessions.when(
        data: (sessions) {
          //lọc
          if (listCategoryOfExpert.contains(AppConstants.health)) {
            healthSessions = sessions
                .where((session) => session.category == AppConstants.health)
                .toList();
          }
          if (listCategoryOfExpert.contains(AppConstants.law)) {
            lawSessions = sessions
                .where((session) => session.category == AppConstants.law)
                .toList();
          }
          if (listCategoryOfExpert.contains(AppConstants.tamly)) {
            tamlySessions = sessions
                .where((session) => session.category == AppConstants.tamly)
                .toList();
          }
          return healthSessions.isEmpty &&
                  lawSessions.isEmpty &&
                  tamlySessions.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(),
                    const AppText20(
                      'Hiện không có câu hỏi nào \nvề lĩnh vực của bạn',
                      maxLines: 2,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    AppButton(
                      ontap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutesNames.editProfile, arguments: true);
                      },
                      name: 'Đổi lại lĩnh vực tư vấn',
                      width: 255,
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.marginHori),
                  child: Column(
                    children: [
                      if (healthSessions.isNotEmpty) ...[
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: AppText16('Sức khoẻ',
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.h),
                        _buildList(healthSessions)
                      ],
                      if (lawSessions.isNotEmpty) ...[
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: AppText16('Pháp luật',
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.h),
                        _buildList(lawSessions)
                      ],
                      if (tamlySessions.isNotEmpty) ...[
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: AppText16('Tâm lý',
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.h),
                        _buildList(tamlySessions)
                      ]
                    ],
                  ),
                );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text('Đã xảy ra lỗi')),
      ),
    );
  }

  Widget _buildList(
    List<AdviseSession> sessions,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return GestureDetector(
          onTap: () {
            //Navigate đến màn hình nhắn tin chi tiết của chuyên gia
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdviseChatDetailScreen(
                  sessionId: session.id,
                  content: session.content,
                ),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: AppImage(
                      imagePath: ImageRes.imgDefaultAvatar,
                      height: 50.h,
                      width: 50.h,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: AppText20(
                      session.content,
                      fontWeight: FontWeight.bold,
                      maxLines: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
