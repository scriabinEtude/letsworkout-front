import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/food_write/food_write_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/model/food_company.dart';
import 'package:letsworkout/model/serving_size.dart';
import 'package:letsworkout/model/thanksto.dart';
import 'package:letsworkout/module/error/letsworkout_error.dart';
import 'package:letsworkout/repository/food_repository.dart';
import 'package:letsworkout/util/string_util.dart';
import 'package:letsworkout/util/widget_util.dart';

class FoodWriteCubit extends Cubit<FoodWriteState> {
  FoodWriteCubit() : super(FoodWriteState());

  final _foodRepository = FoodRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  void setFoodCompany(FoodCompany company) {
    emit(state.copyWith(company: company));
  }

  Future<Food?> validFoodName(String foodName) async {
    try {
      loadingShow();
      emit(state.copyWith(foodName: foodName));

      Food? food = await _foodRepository.validateFood(
        companyName: state.company!.name,
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
    required int firstServingSize,
  }) {
    emit(state.copyWith(
      unit: unit,
      firstServingName: firstServingName,
      firstServingSize: firstServingSize,
    ));
  }

  void setNutirition({
    required double calorie,
    required double carbohydrate,
    required double protein,
    required double fat,
    required double sugar,
    required double sodium,
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

  double _100gFromFirstSize(double value, int firstSize) {
    return double.parse((value * 100 / firstSize).toStringAsFixed(2));
  }

  Future<bool> saveFood({required List<ServingSize> servings}) async {
    loadingShow();
    try {
      final food = Food(
          foodName: state.foodName!,
          company: state.company!,
          unit: state.unit!,
          calorie: _100gFromFirstSize(state.calorie!, state.firstServingSize!),
          carbohydrate:
              _100gFromFirstSize(state.carbohydrate!, state.firstServingSize!),
          protein: _100gFromFirstSize(state.protein!, state.firstServingSize!),
          fat: _100gFromFirstSize(state.fat!, state.firstServingSize!),
          sugar: _100gFromFirstSize(state.sugar!, state.firstServingSize!),
          sodium: _100gFromFirstSize(state.sodium!, state.firstServingSize!),
          description: state.description,
          servingSizes: [
            ServingSize(
                servingName: state.firstServingName!,
                servingSize: state.firstServingSize!),
            ...servings
          ],
          thanksto: [
            Thanksto(
              userId: AppBloc.userCubit.user!.userId!,
              tag: AppBloc.userCubit.user!.tag!,
              description: "최초 등록",
            ),
          ]);

      return await _foodRepository.saveFood(food);
    } catch (e) {
      return false;
    } finally {
      loadingHide();
    }
  }
}
