import 'package:letsworkout/model/workout.dart';

enum BucketPath {
  userProfile('user/profile'),
  diet('diet'),
  workout('workout');

  final String path;

  const BucketPath(this.path);
}
