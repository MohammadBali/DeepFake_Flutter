import 'package:deepfake_detection/models/LoginModel/LoginModel.dart';

class RegisterModel
{
  LoginUser? user;
  String? token;
  int? success;
  RegisterErrorMessage? message; //On Errors

  RegisterModel.fromJson(Map<String,dynamic>json)
  {
    if(json['user']!=null)
    {
      user=LoginUser.fromJson(json['user']);
    }

    if(json['token']!=null)
    {
      token=json['token'];
    }

    if(json['success']!=null)
    {
      success=json['success'];
    }
    if(json['message']!=null)
    {
      message=RegisterErrorMessage.fromJson(json['message']);
    }
  }
}

class RegisterErrorMessage
{
  String? globalMessage;
  String? name;
  String? message;
  RegisterErrorMessage.fromJson(Map<String,dynamic>json)
  {
    globalMessage=json['_message'];
    name=json['name'];
    message=json['message'];
  }
}