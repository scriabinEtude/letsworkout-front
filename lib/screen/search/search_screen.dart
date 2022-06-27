import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/search/search_cubit.dart';
import 'package:letsworkout/bloc/search/search_state.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/screen/calendar/calendar_screen_args.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<SearchCubit, SearchState>(
            bloc: AppBloc.searchCubit,
            builder: (context, state) {
              if (state.searchResult.isEmpty) {
                return const Center(
                  child: Text('결과가 없습니다.'),
                );
              }

              return ListView(
                children: state.searchResult
                    .map((user) => searchUserWidget(user))
                    .toList(),
              );
            }),
      ),
    );
  }

  Widget searchUserWidget(User user) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.calendarScreen,
            arguments: CalendarScreenArgs(user: user));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 100,
        color: Colors.amber,
        child: Text('${user.name} ${user.tag}'),
      ),
    );
  }
}
