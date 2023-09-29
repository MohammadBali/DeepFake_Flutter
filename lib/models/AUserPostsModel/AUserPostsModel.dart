import 'package:deepfake_detection/models/UserDataModel/UserDataModel.dart';
import '../PostModel/PostModel.dart';

class AUserPostsModel
{
  List<Post>? posts=[];
  UserData? owner;

  AUserPostsModel.fromJson(Map<String,dynamic>json)
  {
    try {
      owner=UserData.fromJson(json['owner']);

      json['posts'].forEach((post)
      {
        posts!.add(Post.fromJson(post, user: owner));
      });
    }catch (e,stackTrace)
    {
      print('ERROR WHILE SETTING A USER POSTS MODEL, ${e.toString()} $stackTrace');
    }
  }
}