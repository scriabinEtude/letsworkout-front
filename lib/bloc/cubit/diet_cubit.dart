import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/cubit/diet_state.dart';
import 'package:letsworkout/enum/bucket_path.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/file_actions.dart';
import 'package:letsworkout/repository/diet_repository.dart';
import 'package:letsworkout/util/date_util.dart';

class DietCubit extends Cubit<DietState> {
  DietCubit() : super(DietState());

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
    required FileActions images,
  }) async {
    try {
      setLoading(LoadingState.loading);

      // 이미지 s3에 업로드
      if (!await images.uploadInsertFiles(BucketPath.diet)) {
        return false;
      }

      bool success = await _dietRepository.insertDiet(Diet(
        userId: AppBloc.userCubit.user!.userId!,
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
