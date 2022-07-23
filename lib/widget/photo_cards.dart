import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsworkout/model/file_action.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/util/file_util.dart';

/// ```
///
/// 공통 사진 등록 위젯
/// @param images => 선택된 이미지들이 담김
/// @param onActions
///   PhotoCards는 StatelessWidget이라 행동 이후
///   setState를 하지 않는다.
///   그러므로 setState를 넣어서 위젯 동작후 새로고침 할 수 있게하자.
/// ```
class PhotoCards extends StatelessWidget {
  const PhotoCards({
    Key? key,
    required this.images,
    required this.isViewMode,
    required this.width,
    required this.height,
    this.onActions,
    this.pageController,
    this.boxfit = BoxFit.cover,
  }) : super(key: key);
  final FileActions images;
  final double width;
  final double height;
  final BoxFit boxfit;
  final bool isViewMode;
  final void Function()? onActions;
  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: pageController,
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(),
      child: Row(
        children: [
          ...images.listShowable.map(
            (image) => photoCard(context, image),
          ),
          if (!isViewMode) addPhotoCard(context),
        ],
      ),
    );
  }

  Widget photoCard(BuildContext context, FileAction image) {
    return Stack(
      children: [
        Image(
          image: getImageProvider(image.file),
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
        if (!isViewMode)
          Positioned(
            right: 20,
            top: 20,
            child: InkWell(
              onTap: () {
                images.delete(image);
                if (onActions != null) {
                  onActions!();
                }
              },
              child: const Icon(Icons.cancel),
            ),
          ),
      ],
    );
  }

  Widget addPhotoCard(BuildContext context) {
    return InkWell(
      onTap: () async {
        ImagePicker picker = ImagePicker();
        List<XFile>? files = await picker.pickMultiImage(
          imageQuality: 50,
        );
        if (files == null) return;

        for (XFile file in files) {
          images.add(File(file.path));
        }

        if (onActions != null) {
          onActions!();
        }
      },
      child: Container(
          width: width,
          color: Colors.amber,
          child: const Center(
            child: Icon(
              size: 60,
              Icons.camera_alt_outlined,
            ),
          )),
    );
  }
}
