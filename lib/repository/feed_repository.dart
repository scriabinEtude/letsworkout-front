import 'package:dio/dio.dart';
import 'package:letsworkout/enum/feed_type.dart';
import 'package:letsworkout/model/comment.dart';
import 'package:letsworkout/model/diet.dart';
import 'package:letsworkout/model/feed.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/model/workout.dart';
import 'package:letsworkout/module/api/api.dart';
import 'package:letsworkout/module/error/letsworkout_error.dart';

class FeedRepository {
  String _getUrl(String url) {
    return '/feed$url';
  }

  Future<Feed?> getFeed({required String feedId}) async {
    Response result =
        await api.get(_getUrl('/'), queryParameters: {"feedId": feedId});
    return Feed.fromJson(result.data);
  }

  Future<List<Feed>> getFeedsMonth({
    required String userId,
    required String yearMonth,
  }) async {
    try {
      Response result = await api.get(_getUrl('/month'),
          queryParameters: {'userId': userId, 'yearMonth': yearMonth});
      return result.statusCode == 200 ? Feed.fromJsonList(result.data) : [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<dynamic>> getFeedsDay({
    required String userId,
    required String yearMonthDay,
  }) async {
    try {
      Response result = await api.get(_getUrl('/day'),
          queryParameters: {'userId': userId, 'yearMonthDay': yearMonthDay});

      if (result.statusCode != 200) return [];

      // ActType 따라서 맞는 모델로 변환
      List<dynamic> feeds = result.data;

      feeds = feeds.map((feed) {
        if (feed['actType'] == FeedType.workout.index) {
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
        'id': feed.feedCommentId,
        'feed_id': feed.feedId,
        'actType': feed.feedType,
      });

      return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Feed>> getFeedActives({
    required String userId,
  }) async {
    try {
      Response result = await api.get(_getUrl('/active'), queryParameters: {
        'userId': userId,
      });
      return result.statusCode == 200 ? Feed.fromJsonList(result.data) : [];
    } catch (e) {
      print(e);
      throw LetsworkoutError('feed repository getFeedActives : ', e.toString());
    }
  }

  Future like({
    required User user,
    required String feedId,
    required String feedFcmToken,
  }) async {
    await api.post(_getUrl('/like'), data: {
      'user': user.toJson(),
      'feedId': feedId,
      'feedFcmToken': feedFcmToken,
    });
  }

  Future unLike({
    required User user,
    required String feedId,
    required String feedFcmToken,
  }) async {
    await api.delete(_getUrl('/like'), data: {
      'user': user.toJson(),
      'feedId': feedId,
      'feedFcmToken': feedFcmToken,
    });
  }

  Future comment({
    required String feedFcmToken,
    required Comment comment,
    required bool isMine,
  }) async {
    await api.post(_getUrl('/comment'), data: {
      'comment': comment.toJson(),
      'feedFcmToken': feedFcmToken,
      'isMine': isMine,
    });
  }

  Future commentDelete({
    required String feedFcmToken,
    required Comment comment,
  }) async {
    await api.delete(_getUrl('/comment'), data: {
      'comment': comment.toJson(),
      'feedFcmToken': feedFcmToken,
    });
  }

  Future<List<Comment>> getComments({
    required String feedId,
    required String userId,
  }) async {
    Response result = await api.get(_getUrl('/comments'), queryParameters: {
      'feedId': feedId,
      'userId': userId,
    });

    return Comment.fromJsonList(result.data);
  }

  Future commentLike({
    required String commentId,
    required String userId,
  }) async {
    await api.post(_getUrl('/comment/like'), data: {
      'userId': userId,
      'commentId': commentId,
    });
  }

  Future commentUnLike({
    required String commentId,
    required String userId,
  }) async {
    await api.delete(_getUrl('/comment/like'), data: {
      'userId': userId,
      'commentId': commentId,
    });
  }
}
