import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/search/search_state.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/repository/friend_repository.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit()
      : super(SearchState(
          searchResult: [],
        ));

  final FriendRepository _friendRepository = FriendRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  Future search(String word) async {
    if (word.isEmpty) return;

    try {
      setLoading(LoadingState.loading);

      emit(state.copyWith(
        loading: LoadingState.done,
        searchResult: await _friendRepository.searchFriends(word: word),
      ));
    } catch (e) {
      print(e);
      setLoading(LoadingState.done);
    }
  }
}
