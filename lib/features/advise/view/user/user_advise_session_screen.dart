import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
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
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
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
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.category ?? 'Không rõ lĩnh vực',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.grey[200],
                              child: AppImage(
                                imagePath: ImageRes.avatarDefault,
                                width: 40.r,
                                height: 40.r,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                session.content,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          return Center(child: Text('Error-$error'));
        },
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
  String selectedCategory = AppConstants.tamly;
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
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: <String>[AppConstants.tamly,AppConstants.health, AppConstants.law]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
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
                    category: selectedCategory,
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
