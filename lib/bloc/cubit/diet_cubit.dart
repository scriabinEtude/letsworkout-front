import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/cubit/diet_state.dart';
import 'package:letsworkout/enum/bucket_path.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/repository/diet_repository.dart';
import 'package:letsworkout/util/widget_util.dart';

class DietCubit extends Cubit<DietState> {
  DietCubit() : super(DietState());

  final DietRepository _dietRepository = DietRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future<bool> createDiet({
    required Diet diet,
  }) async {
    try {
      loadingShow();

      // 이미지 s3에 업로드
      if (!await diet.images!.uploadInsertFiles(BucketPath.diet)) {
        return false;
      }

      bool success = await _dietRepository.insertDiet(diet);

      snack('식단 등록이 완료되었습니다!');
      return success;
    } catch (e) {
      print(e);
      return false;
    } finally {
      loadingHide();
    }
  }
}
