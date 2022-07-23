import 'package:dio/dio.dart';
import 'package:letsworkout/enum/act_type.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/feed_active.dart';
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

  Future<List<FeedActive>> getFeedActives({
    required int userId,
  }) async {
    try {
      Response result = await api.get(_getUrl('/active'), queryParameters: {
        'user_id': userId,
      });
      return result.statusCode == 200
          ? FeedActive.fromJsonList(result.data)
          : [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future like({
    required int feedId,
    required int userId,
  }) async {
    await api.post(_getUrl('/like'), data: {
      'user_id': userId,
      'feed_id': feedId,
    });
  }

  Future unLike({
    required int feedId,
    required int userId,
  }) async {
    await api.delete(_getUrl('/like'), data: {
      'user_id': userId,
      'feed_id': feedId,
    });
  }

  Future comment({
    required int userId,
    required int feedId,
    required int depth,
    required int? parentId,
    required String comment,
  }) async {
    await api.post(_getUrl('/comment'), data: {
      'user_id': userId,
      'feed_id': feedId,
      'depth': depth,
      'parent_id': parentId,
      'comment': comment,
    });
  }

  Future commentDelete({
    required int commentId,
  }) async {
    await api.delete(_getUrl('/comment'), data: {
      'id': commentId,
    });
  }

  Future<List<Comment>> getComments({
    required int feedId,
    required int userId,
  }) async {
    Response result = await api.get(_getUrl('/comments'), queryParameters: {
      'feed_id': feedId,
      'user_id': userId,
    });

    return Comment.fromJsonList(result.data);
  }

  Future commentLike({
    required int commentId,
    required int userId,
  }) async {
    await api.post(_getUrl('/comment/like'), data: {
      'user_id': userId,
      'comment_id': commentId,
    });
  }

  Future commentUnLike({
    required int commentId,
    required int userId,
  }) async {
    await api.delete(_getUrl('/comment/like'), data: {
      'user_id': userId,
      'comment_id': commentId,
    });
  }
}
