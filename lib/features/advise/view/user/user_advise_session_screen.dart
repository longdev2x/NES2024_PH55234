import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/advise_entity.dart';
import 'package:nes24_ph55234/data/repositories/advise_repos.dart';
import 'package:nes24_ph55234/features/advise/controller/advise_provider.dart';
import 'package:nes24_ph55234/features/advise/view/advise_chat_detail_screen.dart';
import 'package:nes24_ph55234/global.dart';
import 'package:nes24_ph55234/main.dart';

class UserAdviseSessionScreen extends ConsumerWidget {
  const UserAdviseSessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchSessions = ref.watch(adviseSessionsProvider);

    return Scaffold(
      appBar: appGlobalAppBar('Tư vấn tâm lý'),
      body: fetchSessions.when(
        data: (sessions) {
          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              if (sessions.isEmpty) {
                return const Center(
                  child: Text('Chưa có cuộc tư vấn nào'),
                );
              }
              final session = sessions[index];
              return ListTile(
                  leading: const AppImage(
                    imagePath: ImageRes.avatarDefault,
                  ),
                  title: Text(session.content),
                  onTap: () {
                    //Navigate tới màn hình nhắn tin chi tiết
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AdviseChatDetailScreen(sessionId: session.id, content: session.content,),
                      ),
                    );
                  });
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          return const Center(child: Text('Error'));
        } 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateAdviseScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateAdviseScreen extends ConsumerStatefulWidget {
  const CreateAdviseScreen({super.key});

  @override
  ConsumerState createState() => _CreateAdviseScreenState();
}

class _CreateAdviseScreenState extends ConsumerState<CreateAdviseScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo yêu cầu tư vấn mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Nhập nội dung cần tư vấn...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  final session = AdviseSession(
                    userId: Global.storageService.getUserId(),
                    content: _controller.text,
                    messages: [],
                    createdAt: DateTime.now(),
                  );
                  await AdviseRepos.createAdviseSession(session);
                  navKey.currentState!.pop();
                }
              },
              child: const Text('Gửi'),
            ),
          ],
        ),
      ),
    );
  }
}
