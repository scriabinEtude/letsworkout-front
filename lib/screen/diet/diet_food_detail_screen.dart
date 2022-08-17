import 'package:flutter/material.dart';
import 'package:letsworkout/model/food.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/repository/user_repository.dart';
import 'package:letsworkout/widget/avatar.dart';

class DietFoodDetailScreen extends StatefulWidget {
  const DietFoodDetailScreen({
    Key? key,
    required this.food,
  }) : super(key: key);
  final Food food;

  @override
  State<DietFoodDetailScreen> createState() => _DietFoodDetailScreenState();
}

class _DietFoodDetailScreenState extends State<DietFoodDetailScreen> {
  final _userRepository = UserRepository();
  late final Food food;

  @override
  void initState() {
    food = widget.food;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('음식 정보')),
      body: ListView(
        children: [
          Text('음식이름 ${food.foodName}'),
          Text('브랜드 ${food.company}'),
          Text('인용횟수 ${food.refCount}'),
          FutureBuilder<List<User>?>(
            future: _userRepository.getUsersById(
                food.thanksto?.map((e) => e.userId).toList() ?? []),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) return const SizedBox.shrink();

                return Column(
                    children: snapshot.data!
                        .map((user) => Row(
                              children: [
                                Avatar(
                                  size: 30,
                                  image: user.profileImage,
                                ),
                                Column(
                                  children: [
                                    Text(user.tag!),
                                    Text(user.name!),
                                  ],
                                )
                              ],
                            ))
                        .toList());
              } else {
                return SizedBox.shrink();
              }
            }),
          ),
          // if (user != null) Text('등록한 사람 ${user!.name ?? ""}'),
          Text('칼로리 ${food.calorie}'),
          Text('탄수화물 ${food.carbohydrate}'),
          Text('단백질 ${food.protein}'),
          Text('지방 ${food.fat}'),
          Text('당 ${food.sugar}'),
          Text('나트륨 ${food.sodium}'),
          Text('설명 ${food.description}'),
        ],
      ),
    );
  }
}
