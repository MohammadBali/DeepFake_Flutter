import 'package:deepfake_detection/models/InquiryModel/InquiryModel.dart';
import 'package:deepfake_detection/models/UserDataModel/UserDataModel.dart';

class PostModel
{
  List<Post>? posts=[];

  PostModel.fromJson(Map<String,dynamic>json)
  {
    try
    {
      json['posts'].forEach((post)
      {
        posts!.add(Post.fromJson(post));
      });
    }
    catch(e)
    {
      print('ERROR WHILE SETTING POST-MODEL CLASS, ${e.toString()}');
    }
  }
}

class Post
{
  String? title;
  String? id;
  Inquiry? inquiry;
  UserData? owner;

  List<Likes>? likes=[];

  Post.fromJson(Map<String,dynamic>json)
  {
    try
    {
      title= json['title'];

      id=json['_id'];

      inquiry=Inquiry.fromJson(json['inquiry']);

      owner=UserData.fromJson(json['inquiry']['owner']);

      json['likes'].forEach((like)
      {
        likes!.add(Likes.fromJson(like));
      });
    }
    catch(e)
    {
      print('ERROR WHILE SETTING POST CLASS MODEL, ${e.toString()}');
    }
  }
}

class Likes
{
  String? owner;
  String? id;
  
  Likes.fromJson(Map<String,dynamic>json)
  {
    owner=json['owner'];
    id=json['_id'];
  }
}