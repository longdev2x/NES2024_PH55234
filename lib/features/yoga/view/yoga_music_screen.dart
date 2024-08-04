import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/music_entity.dart';
import 'package:nes24_ph55234/data/repositories/music_repos.dart';
import 'package:nes24_ph55234/features/yoga/controller/music_provider.dart';
import 'package:file_picker/file_picker.dart';

class YogaMusicScreen extends ConsumerWidget {
  const YogaMusicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicPlayerState = ref.watch(musicPlayerProvider);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Yoga Music'),
      //   // actions: [
      //   //   ElevatedButton(
      //   //     onPressed: _uploadMusic,
      //   //     child: const Text('Upload Music'),
      //   //   )
      //   // ],
      // ),
      body: musicPlayerState.when(
        data: (state) => Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.marginHori,vertical: 12.h),
          child: ListView.builder(
            itemCount: state.playlist.length,
            itemBuilder: (context, index) {
              final song = state.playlist[index];
              return GestureDetector(
                onTap: () {
                  if (state.currentSong?.id == song.id &&
                      state.playerState.playing) {
                    ref.read(musicPlayerProvider.notifier).pause();
                  } else {
                    ref.read(musicPlayerProvider.notifier).play(song);
                  }
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: const AppImage(
                            imagePath: ImageRes.yogaBanner,
                            width: 60,
                            height: 60,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        AppText20(
                          song.title,
                          fontWeight: FontWeight.bold,
                        ),
                        const Spacer(),
                        AppImage(
                          imagePath: state.currentSong?.id == song.id &&
                                  state.playerState.playing
                              ? ImageRes.icPlayVideo
                              : ImageRes.icPause,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _uploadMusic() async {
    try {
      // Chọn file nhạc
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;

        // Upload file lên Firebase Storage
        String downloadUrl = await MusicRepos.uploadAudio(file, fileName);

        // Tạo đối tượng MusicEntity
        MusicEntity newMusic = MusicEntity(
          title: fileName,
          url: downloadUrl,
        );

        // Lưu thông tin vào Firestore
        await MusicRepos.saveMusicInfo(newMusic);

        print('zzzUp nhạc thành công');
      }
    } catch (e) {
      print('zzzUp nhạc lỗi: $e');
    }
  }
}
