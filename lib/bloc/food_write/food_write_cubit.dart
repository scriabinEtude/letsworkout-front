import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/food_write/food_write_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/module/error/letsworkout_error.dart';
import 'package:letsworkout/repository/food_repository.dart';
import 'package:letsworkout/util/widget_util.dart';

class FoodWriteCubit extends Cubit<FoodWriteState> {
  FoodWriteCubit() : super(FoodWriteState());

  final _foodRepository = FoodRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  void setCompanyName(String companyName) {
    emit(state.copyWith(companyName: companyName));
  }

  Future<Food?> validFoodName(String foodName) async {
    try {
      loadingShow();
      emit(state.copyWith(foodName: foodName));

      Food? food = await _foodRepository.validateFood(
        company: state.companyName!,
        foodName: state.foodName!,
      );

      return food;
    } catch (e) {
      print(e);
      throw LetsworkoutError('서버오류입니다.');
    } finally {
      loadingHide();
    }
  }

  void setFirstServing({
    required String unit,
    required String firstServingName,
    required String firstServingSize,
  }) {
    emit(state.copyWith(
      unit: unit,
      firstServingName: firstServingName,
      firstServingSize: firstServingSize,
    ));
  }

  void setNutirition({
    required int calorie,
    required int carbohydrate,
    required int protein,
    required int fat,
    required int sugar,
    required int sodium,
    required String description,
  }) {
    emit(state.copyWith(
      calorie: calorie,
      carbohydrate: carbohydrate,
      protein: protein,
      fat: fat,
      sugar: sugar,
      sodium: sodium,
      description: description.isNotEmpty ? description : null,
    ));
  }
}
