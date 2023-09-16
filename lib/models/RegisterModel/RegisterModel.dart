import 'package:deepfake_detection/models/LoginModel/LoginModel.dart';

class RegisterModel
{
  LoginUser? user;
  String? token;
  int? success;
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
  }
}