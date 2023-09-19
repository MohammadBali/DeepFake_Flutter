import 'package:deepfake_detection/models/InquiryModel/InquiryModel.dart';
import 'package:deepfake_detection/models/UserDataModel/UserDataModel.dart';

class PostModel
{
  List<Post>? posts=[];
  Pagination? pagination;

  PostModel.fromJson(Map<String,dynamic>json)
  {
    try
    {
      json['posts'].forEach((post)
      {
        posts!.add(Post.fromJson(post));
      });

      if(json['pagination'] !=null)
        {
          pagination=Pagination.fromJson(json['pagination']);
        }
    }
    catch(e)
    {
      print('ERROR WHILE SETTING POST-MODEL CLASS, ${e.toString()}');
    }
  }
}


class Pagination
{
  int? currentPage;
  int? totalPages;
  String? nextPage;
  String? previousPage;

  Pagination.fromJson(Map<String,dynamic>json)
  {
    currentPage=json['currentPage'];
    totalPages=json['totalPages'];
    nextPage=json['nextPage'];
    previousPage=json['previousPage'];
  }
}

class Post
{
  String? title;
  String? id;
  Inquiry? inquiry;
  UserData? owner;

  String? createdAt;

  List<Like>? likes=[];

  List<Comment>? comments=[];

  Post.fromJson(Map<String,dynamic>json)
  {
    try
    {
      title= json['title'];

      id=json['_id'];

      inquiry=Inquiry.fromJson(json['inquiry']);

      owner=UserData.fromJson(json['inquiry']['owner']);

      createdAt=json['createdAt'];

      json['likes'].forEach((like)
      {
        likes!.add(Like.fromJson(like));
      });

      json['comments'].forEach((comment)
      {
        comments!.add(Comment.fromJson(comment));
      });


    }
    catch(e)
    {
      print('ERROR WHILE SETTING POST CLASS MODEL, ${e.toString()}');
    }
  }
}

class Like
{
  String? owner;
  String? id;
  
  Like.fromJson(Map<String,dynamic>json)
  {
    owner=json['owner'];
    id=json['_id'];
  }
}

class Comment
{
  String? comment;
  UserData? owner;
  String? id;

  Comment.fromJson(Map<String,dynamic> json)
  {
    try
    {
      comment=json['comment'];
      owner=UserData.fromJson(json['owner']);
      id=json['_id'];
    }
    catch(e)
    {
      print('ERROR WHILE SETTING DATA IN COMMENT CLASS MODEL, ${e.toString()}');
    }
  }
}