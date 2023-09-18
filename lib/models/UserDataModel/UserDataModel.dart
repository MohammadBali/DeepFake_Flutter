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
      photo=json['photo'];

      if(json['birthDate']!=null)
        {
          gender=json['birthDate'];
        }

      if(json['email']!=null)
        {
          email=json['email'];
        }

    }
    catch(error)
    {
      print('ERROR WHILE INSERTING DATA IN USERDATA, ${error.toString()}');
    }
  }
}