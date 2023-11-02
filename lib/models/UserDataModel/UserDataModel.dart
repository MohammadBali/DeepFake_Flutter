class UserData
{
  String? id;
  String? name;
  String? lastName;
  String? gender;
  String? birthDate;
  String? email;
  String? photo;
  bool? isOfficial;

  UserData.fromJson(Map<String,dynamic>json)
  {
    try
    {
      id=json['_id'];
      name=json['name'];
      lastName=json['last_name'];
      photo=json['photo'];
      gender=json['gender'];

      if(json['birthDate']!=null)
        {
          gender=json['birthDate'];
        }

      if(json['email']!=null)
        {
          email=json['email'];
        }

      if(json['isOfficial'] !=null)
        {
          isOfficial=json['isOfficial'];
        }

    }
    catch(error)
    {
      print('ERROR WHILE INSERTING DATA IN USERDATA, ${error.toString()}');
    }
  }
}