class LoginModel
{
  LoginUser? user;
  String? token;
  int? success;
  LoginModel.fromJson(Map<String,dynamic>json)
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

class LoginUser
{
  String? id;
  String? name;
  String? gender;
  String? birthDate;
  String? email;
  String? photo;

  LoginUser.fromJson(Map<String,dynamic>json)
  {
    id=json['_id'];
    name=json['name'];
    gender=json['birthDate'];
    email=json['email'];
    photo=json['photo'];
  }
}