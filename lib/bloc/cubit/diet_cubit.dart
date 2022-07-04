import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/cubit/diet_state.dart';
import 'package:letsworkout/config/constant.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/signed_url.dart';
import 'package:letsworkout/repository/app_repository.dart';
import 'package:letsworkout/repository/diet_repository.dart';
import 'package:letsworkout/util/date_util.dart';

class DietCubit extends Cubit<DietState> {
  DietCubit() : super(DietState());

  final AppRepository _appRepository = AppRepository();
  final DietRepository _dietRepository = DietRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future<bool> createDiet({
    required DateTime time,
    required String? description,
    required int? calorie,
    required int? carbohydrate,
    required int? protein,
    required int? fat,
    required List<File> imageFiles,
  }) async {
    try {
      setLoading(LoadingState.loading);
      List<String> images = [];

      // 이미지 s3에 업로드
      if (imageFiles.isNotEmpty) {
        // signedurls
        List<SignedUrl>? urls = await _appRepository.getSignedUrls(
            path: imagePath_diet, images: imageFiles);
        if (urls == null) return false;

        // upload
        for (var i = 0; i < urls.length; i++) {
          images.add(urls[i].url);
          bool success =
              await _appRepository.s3upload(url: urls[i], file: imageFiles[i]);
          if (!success) return false;
        }
      }

      bool success = await _dietRepository.insertDiet(Diet(
        userId: AppBloc.userCubit.user!.id!,
        time: mysqlDateTimeFormat(time),
        description: description,
        calorie: calorie,
        carbohydrate: carbohydrate,
        protein: protein,
        fat: fat,
        images: images,
      ));

      return success;
    } catch (e) {
      print(e);
      return false;
    } finally {
      setLoading(LoadingState.done);
    }
  }
}
