import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/models/InquiryModel/InquiryModel.dart';
import 'package:deepfake_detection/models/UserDataModel/UserDataModel.dart';

class PostModel
{
  List<Post>? posts=[];
  Pagination? pagination;

  PostModel.fromJson(Map<String,dynamic>json, {bool isOwnerUser=false})  //isOwnerUser is for GetUserPosts, I don't want to pass the owner data because it's ths user's =>Will match it automatically with the logged in user
  {
    try
    {
      json['posts'].forEach((post)
      {
        posts!.add(Post.fromJson(post, isOwnerUser: isOwnerUser));
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

  Post.fromJson(Map<String,dynamic>json, {bool isOwnerUser=false})
  {
    try
    {
      title= json['title'];

      id=json['_id'];

      if(isOwnerUser)
        {
          owner=AppCubit.userData;
        }

      else
        {
          owner=UserData.fromJson(json['owner']);
        }

      inquiry=Inquiry.fromJson(json['inquiry']);

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
    catch(e,stackTrace)
    {
      print('ERROR WHILE SETTING POST CLASS MODEL, ${e.toString()}');
      print('Stack Trace:\n$stackTrace');
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

