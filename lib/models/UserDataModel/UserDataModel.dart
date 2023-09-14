class UserData
{
  String? id;
  String? name;
  String? gender;
  String? birthDate;
  String? email;
  String? photo;

  UserData.fromJson(Map<String,dynamic>json)
  {
    try
    {
      id=json['_id'];
      name=json['name'];
      gender=json['birthDate'];
      email=json['email'];
      photo=json['photo'];
    }
    catch(error)
    {
      print('ERROR WHILE INSERTING DATA IN USERDATA, ${error.toString()}');
    }
  }
}