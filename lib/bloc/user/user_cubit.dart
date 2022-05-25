import 'package:bloc/bloc.dart';
import 'package:letsworkout/config/preference.dart';
import 'package:letsworkout/model/user.dart';

class UserCubit extends Cubit<User?> {
  UserCubit() : super(null);

  Future<User?> loadInitialData() async {
    User? user = await Preferences.getUser();
    emit(user);
    return user;
  }

  Future<void> setUser(User user) async {
    await Preferences.setUser(user);
    emit(user);
  }

  User? get user => state;
}
