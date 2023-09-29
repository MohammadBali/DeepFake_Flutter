class InquiryModel
{
  List<Inquiry>? inquiries=[];

  InquiryModel.fromJson(Map<String,dynamic>json)
  {
    try
    {
      json['inquiries'].forEach((inquiry)
      {
        inquiries!.add(Inquiry.fromJson(inquiry));
      });
    }
    catch(e)
    {
      print('ERROR WHILE SETTING DATA IN INQUIRY-MODEL, ${e.toString()}');
    }
  }
}


class Inquiry
{
  String? id;
  String? name;
  String? type;
  String? data; //is in Base64 and Needs conversion
  //String? owner;
  String? result;
  String? createdAt;

  Inquiry.fromJson(Map<String,dynamic>json)
  {
    try
    {
      id=json['_id'];
      name=json['name'];
      type=json['type'];
      //owner=json['owner'];
      result=json['result'];
      createdAt=json['createdAt'];
      data=json['data'];
    }
    catch(e, stackTrace)
    {
      print('ERROR WHILE SETTING DATA IN INQUIRY CLASS MODEL, ${e.toString()}, $stackTrace');
    }
  }
}