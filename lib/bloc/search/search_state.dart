import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/user.dart';

class SearchState {
  final LoadingState loading;
  final String keyword;
  final List<User> searchResult;

  SearchState({
    this.loading = LoadingState.init,
    this.keyword = "",
    required this.searchResult,
  });

  SearchState copyWith({
    LoadingState? loading,
    String? keyword,
    List<User>? searchResult,
  }) =>
      SearchState(
        loading: loading ?? this.loading,
        keyword: keyword ?? this.keyword,
        searchResult: searchResult ?? this.searchResult,
      );
}
