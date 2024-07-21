import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/features/grateful/controller/grateful_provider.dart';
import 'package:nes24_ph55234/features/grateful/controller/post_grateful_provider.dart';

class PostBottomScreen extends ConsumerStatefulWidget {
  const PostBottomScreen({super.key});

  @override
  ConsumerState<PostBottomScreen> createState() => _PostBottomScreenState();
}

class _PostBottomScreenState extends ConsumerState<PostBottomScreen> {
  late final List<dynamic> _items = [];
  final ImagePicker _picker = ImagePicker();
  late PostEntity objPost;
  late final TextEditingController _titleController;
  int _currentFocusIndex = 0;
  @override
  void initState() {
    super.initState();
    objPost = ref.read(createPostGratefulProvider);
    _titleController = TextEditingController();
    _titleController.text = objPost.title ?? '';
    //Phần content
    List<ContentItem> contentItems = objPost.contentItems;
    for (ContentItem c in contentItems) {
      if (c.type == 'text') {
        final TextEditingController contro = TextEditingController();
        contro.text = c.content ?? '';
        _items.add(contro);
      } else if (c.type == 'image' && c.content != null) {
        _items.add(c.content);
      } else {
        _items.add(c.imageFile);
      }
    }
    //Trường hợp contentItems rỗng hoặc image cuối
    if (_items.isEmpty || _items.last is File) {
      _items.add(TextEditingController());
    }
  }

  Widget _buildImageWidget(dynamic item) {
    if (item is File) {
      return Image.file(
        item,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      );
    } else if (item is String) {
      return Image.network(
        item,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      );
    }
    return const SizedBox();
  }

  void _handleTextChange(String value, int index) {
    if (value.isEmpty && _items.length > 1) {
      if (_items[index - 1] is File) return;
      setState(() {
        _items.removeAt(index);
        if (index > 0) {
          _currentFocusIndex = index - 1;
        }
      });
      if (index > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).previousFocus();
        });
      }
    } else if (value.endsWith('\n')) {
      setState(() {
        _items.insert(index + 1, TextEditingController());
        _currentFocusIndex = index + 1;
        _items[index].text = _items[index].text.trimRight();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).nextFocus();
      });
    }
  }

  Widget _emojiDialog(BuildContext context,
          {required CreatePostNotifer notifier}) =>
      Dialog(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppText16(
                'Ngày hôm nay của bạn thế nào?',
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 150.h,
                width: 300.w,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h),
                    itemCount: PostFeel.values.length,
                    itemBuilder: (ctx, index) {
                      return AppImage(
                          onTap: () {
                            notifier.updateState(feel: PostFeel.values[index]);
                            Navigator.pop(context);
                          },
                          imagePath: emoijMap[PostFeel.values[index]]);
                    }),
              ),
            ],
          ),
        ),
      );

  void _addImage() async {
    final List<XFile> images = await _picker.pickMultiImage();
    setState(() {
      for (var xFile in images) {
        _items.insert(_currentFocusIndex + 1, File(xFile.path));
        _currentFocusIndex++;
      }
      if (_currentFocusIndex == _items.length - 1) {
        _items.insert(_currentFocusIndex + 1, TextEditingController());
        _currentFocusIndex++;
      }
    });
  }

  void _saveLocalProvider() {
    ref.read(createPostGratefulProvider.notifier).updateState(
          contentItems: _items.map((e) {
            if (e is File) {
              return ContentItem(type: 'image', imageFile: e);
            } else {
              return ContentItem(
                  type: 'text', content: (e as TextEditingController).text);
            }
          }).toList(),
          title: _titleController.text,
        );
  }

  void _post() {
    _saveLocalProvider();
    PostEntity objPost = ref.read(createPostGratefulProvider);
    ref.read(gratefulProvider.notifier).createPost(objPost);
  }

  @override
  Widget build(BuildContext context) {
    objPost = ref.watch(createPostGratefulProvider);
    final CreatePostNotifer notifier =
        ref.read(createPostGratefulProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 120.h,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AppConfirm(
                  title: 'Dữ liệu sẽ không được lưu, bạn chắc chứ?',
                  onConfirm: () {
                    _saveLocalProvider();
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  }),
            );
          },
          icon: const Icon(Icons.close),
        ),
        title: const AppText20(
          'Nhật ký biết ơn',
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              _saveLocalProvider();
              _post();
            },
            child: const AppText20('Lưu'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      iconSize: 30.r,
                      value: objPost.limit!.name,
                      items: PostLimit.values
                          .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e == PostLimit.private
                                  ? 'Chỉ mình tôi'
                                  : 'Công khai')))
                          .toList(),
                      onChanged: (value) {
                        notifier.updateState(
                          limit: PostLimit.values.firstWhere(
                            (e) => e.name == value,
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) =>
                              _emojiDialog(ctx, notifier: notifier),
                        );
                      },
                      child: AppImage(
                        imagePath: emoijMap[objPost.feel],
                        height: 60,
                        width: 60,
                        boxFit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
                AppTextFieldNoborder(
                  hintText: 'Tiêu đề',
                  fontSize: 25.sp,
                  controller: _titleController,
                  maxLines: null,
                  inputType: TextInputType.multiline,
                  fontWeight: FontWeight.bold,
                  maxLength: 50,
                  paddingContent: const EdgeInsets.only(left: 0),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.marginHori),
              itemCount: _items.length,
              itemBuilder: (ctx, index) {
                if (_items[index] is File || _items[index] is String) {
                  return _buildImageWidget(_items[index]);
                } else {
                  return AppTextFieldNoborder(
                    controller: _items[index],
                    hintText: 'Viết thêm ở đây...',
                    fontSize: 18.sp,
                    maxLines: 10,
                    width: double.infinity,
                    inputType: TextInputType.multiline,
                    paddingContent:
                        EdgeInsets.only(left: 0, top: 10.h, bottom: 10.h),
                    onTap: () {
                      _currentFocusIndex = index;
                    },
                    onChanged: (value) {
                      _handleTextChange(value, index);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 10.w,
          right: 10.w,
        ),
        child: Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _addImage,
                icon: const AppIcon(path: ImageRes.icAddImage),
              ),
              // Thêm các nút chức năng khác ở đây
            ],
          ),
        ),
      ),
    );
  }
}
