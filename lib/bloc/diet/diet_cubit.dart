import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/diet/diet_state.dart';
import 'package:letsworkout/enum/bucket_path.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/repository/diet_repository.dart';
import 'package:letsworkout/util/widget_util.dart';

class DietCubit extends Cubit<DietState> {
  DietCubit() : super(DietState());

  final DietRepository _dietRepository = DietRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future<bool> createDiet({
    required Feed feed,
  }) async {
    try {
      loadingShow();

      // 이미지 s3에 업로드
      if (!await feed.images!.uploadInsertFiles(BucketPath.diet)) {
        return false;
      }

      bool success = await _dietRepository.insertDiet(feed);

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
