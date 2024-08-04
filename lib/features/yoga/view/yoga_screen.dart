import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/video_entity.dart';
import 'package:nes24_ph55234/features/yoga/controller/video_provider.dart';
import 'package:nes24_ph55234/features/yoga/view/yoga_widgets.dart';
import 'package:nes24_ph55234/main.dart';

class YogaScreen extends ConsumerWidget {
  const YogaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchList = ref.watch(getListVideoFutureProvider);
    return Scaffold(
      appBar: appGlobalAppBar('Thiền và Yoga'),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: SingleChildScrollView(
          child: fetchList.when(
              data: (listVideo) {
                print('zzz-listvideolength-${listVideo.length}');
                final List<VideoEntity> listThien = listVideo
                    .where((video) => video.type == AppConstants.typeVideoThien)
                    .toList()
                    .sublist(0, 4);
                final List<VideoEntity> listYoga = listVideo
                    .where((video) => video.type == AppConstants.typeVideoYoga)
                    .toList()
                    .sublist(0, 4);
                print('zzz-listThienlength-${listThien.length}');
                print('zzz-listYogalength-${listYoga.length}');
                return Column(
                  children: [
                    YogaMenu(
                        name: 'Yoga',
                        onTapMore: () {
                          _onTapMoreVideo('yoga');
                        }),
                    SizedBox(height: 10.h),
                    listYoga.isEmpty
                        ? const Center(child: Text('Hiện chưa có video'))
                        : CourseItemGrid(listYoga),
                    SizedBox(height: 20.h),
                    YogaMenu(
                        name: 'Thiền',
                        onTapMore: () {
                          _onTapMoreVideo('thien');
                        }),
                    SizedBox(height: 10.h),
                    listThien.isEmpty
                        ? const Center(child: Text('Hiện chưa có video'))
                        : CourseItemGrid(listThien),
                    SizedBox(height: 70.h),
                    OutlinedButton.icon(
                      icon: const AppImage(imagePath: ImageRes.icUploadVideo, height: 25, width: 25,),
                      onPressed: () {
                        uploadVideo(ref);
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 5,
                        side: BorderSide(color: Colors.indigo[400]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                      ),
                      label: AppText16(
                        'Upload Video',
                        color: Colors.indigo[700],
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                );
              },
              error: (error, stackTrace) {
                return const Center(
                  child: Text('Error'),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }

  void _onTapMoreVideo(String type) {
    navKey.currentState!
        .pushNamed(AppRoutesNames.yogaFullVideos, arguments: type);
  }

  void uploadVideo(WidgetRef ref) {
    showModalBottomSheet(
    context: ref.context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return UploadVideoBottomSheet();
    },
  );
    // VideoEntity objVideo = VideoEntity(
    //   type: AppConstants.typeVideoThien,
    //   title: 'Thiền định 5',
    //   des:
    //       'Thực hiện tư thế xếp bằng, lưng thẳng, cơ bụng thả lỏng. Miệng nhẩm câu “Om Shanti” trong 1 phút. Đây là hình thức cầu nguyện quan trọng của đạo Hindu. Quá trình này sẽ giúp tâm hồn bạn được thư giãn hơn và các suy nghĩ dần lắng đọng. Bạn cũng có thể chắp tay cầu nguyện trong thời gian này để tinh thần được thả lỏng hoàn toàn.',
    //   thumbnail:
    //       'https://static.tuoitre.vn/tto/i/s626/2016/07/09/hinh-5-1468028701.jpg',
    //   updateAt: DateTime.now(),
    // );

    // // 'https://cdn.hellobacsi.com/wp-content/uploads/2019/07/tam-gi%C3%A1c.png'
    // ref
    //     .read(getListVideoFutureProvider.notifier)
    //     .uploadVideo(objVideo: objVideo);
  }
}


class UploadVideoBottomSheet extends ConsumerStatefulWidget {
  const UploadVideoBottomSheet({super.key});
  @override
  ConsumerState<UploadVideoBottomSheet> createState() => _UploadVideoBottomSheetState();
}

class _UploadVideoBottomSheetState extends ConsumerState<UploadVideoBottomSheet> {
  String selectedType = AppConstants.typeVideoYoga;
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  File? thumbnailImage;
  File? videoFile;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    desController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppText16('Upload Video', fontWeight: FontWeight.bold),
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              Radio(
                value: AppConstants.typeVideoYoga,
                groupValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value as String;
                  });
                },
              ),
              const AppText14('Yoga'),
              const Spacer(),
              Radio(
                value: AppConstants.typeVideoThien,
                groupValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value as String;
                  });
                },
              ),
              const AppText14('Thiền Định'),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            controller: titleController,
            lable: 'Tên Video',
          ),
          AppTextFieldNoborder(
            controller: desController,
            hintText: 'Mô tả Video',
            maxLength: 500,
            maxLines: 10,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pickThumbnail,
            child: const AppText14('Chọn Thumbnail'),
          ),
          if (thumbnailImage != null)
            Image.file(thumbnailImage!, height: 100, width: 100),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pickVideo,
            child: const AppText14('Chọn Video'),
          ),
          if (videoFile != null)
            AppText14('Đã chọn video: ${videoFile!.path.split('/').last}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _uploadVideo(ref);
            } ,
            child: const AppText14('Tải lên'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickThumbnail() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        thumbnailImage = File(image.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        videoFile = File(video.path);
      });
    }
  }

  void _uploadVideo(WidgetRef ref) {
    if (titleController.text.isEmpty || thumbnailImage == null || videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    VideoEntity objVideo = VideoEntity(
      type: selectedType,
      title: titleController.text,
      des: desController.text,  
      fileVideo: videoFile,
      fileImage: thumbnailImage,
      updateAt: DateTime.now(),
    );

    ref.read(getListVideoFutureProvider.notifier).uploadVideo(objVideo: objVideo);

    Navigator.of(context).pop(); 
  }
}