import 'package:dio/dio.dart';
import 'package:letsworkout/enum/act_type.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/module/api/api.dart';

class FeedRepository {
  String _getUrl(String url) {
    return '/feed$url';
  }

  Future<List<Feed>> getFeedsMonth({
    required int userId,
    required String yearMonth,
  }) async {
    try {
      Response result = await api.get(_getUrl('/month'),
          queryParameters: {'user_id': userId, 'year_month': yearMonth});
      return result.statusCode == 200 ? Feed.fromJsonList(result.data) : [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<dynamic>> getFeedsDay({
    required int userId,
    required String yearMonthDay,
  }) async {
    try {
      Response result = await api.get(_getUrl('/day'),
          queryParameters: {'user_id': userId, 'year_month_day': yearMonthDay});

      if (result.statusCode != 200) return [];

      // ActType 따라서 맞는 모델로 변환
      List<dynamic> feeds = result.data;

      feeds = feeds.map((feed) {
        if (feed['act_type'] == ActType.workout.index) {
          return Workout.fromJson(feed);
        } else {
          return Diet.fromJson(feed);
        }
      }).toList();

      return feeds;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> deleteFeed({
    required dynamic feed,
  }) async {
    try {
      Response result = await api.delete(_getUrl('/'), data: {
        'id': feed.id,
        'feed_id': feed.feedId,
        'act_type': feed.actType,
      });

      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}