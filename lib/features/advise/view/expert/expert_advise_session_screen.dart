import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/features/advise/controller/advise_provider.dart';
import 'package:nes24_ph55234/features/advise/view/advise_chat_detail_screen.dart';

class ExpertAdviseSessionScreen extends ConsumerWidget {
  const ExpertAdviseSessionScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchSessions = ref.watch(adviseSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách yêu cầu tư vấn')),
      body: fetchSessions.when(
        data: (sessions) => ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return ListTile(
              trailing: const AppImage(
                imagePath: ImageRes.avatarDefault,
              ),
              title: Text(session.content),
              onTap: () {
                //Navigate đến màn hình nhắn tin chi tiết của chuyên gia
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdviseChatDetailScreen(sessionId: session.id),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text('Đã xảy ra lỗi')),
      ),
    );
  }
}
