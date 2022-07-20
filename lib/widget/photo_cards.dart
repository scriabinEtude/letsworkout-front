import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
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
    required this.onActions,
    required this.isViewMode,
    this.size,
  }) : super(key: key);
  final FileActions images;
  final void Function() onActions;
  final double? size;
  final bool isViewMode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 400,
        child: PageView(
          allowImplicitScrolling: true,
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            ...images.listShowable.map(
              (image) => photoCard(context, image),
            ),
            if (!isViewMode) addPhotoCard(context),
          ],
        ),
      ),
      // child: CarouselSlider(
      //   options: CarouselOptions(
      //     enableInfiniteScroll: false,
      //   ),
      //   items: [
      //     ...images.listShowable.map(
      //       (image) => photoCard(context, image),
      //     ),
      //     if (!isViewMode) addPhotoCard(context),
      //   ],
      // ),
    );
  }

  Widget photoCard(BuildContext context, FileAction image) {
    return Stack(
      children: [
        Image(
          image: getImageProvider(image.file),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
        ),
        if (!isViewMode)
          Positioned(
            right: 20,
            top: 20,
            child: InkWell(
              onTap: () {
                images.delete(image);
                onActions();
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
          imageQuality: 20,
        );
        if (files == null) return;

        for (XFile file in files) {
          images.add(File(file.path));
        }
        onActions();
      },
      child: Container(
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
