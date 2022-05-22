import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app/app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState());

  void appSnackBar(String message) {
    emit(state.copyWith(message: message));
  }
}
