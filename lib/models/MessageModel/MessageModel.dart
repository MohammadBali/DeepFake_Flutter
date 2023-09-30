class MessageModel
{
  List<Message>? messages=[];

  MessageModel()
  {
    messages= [];
  }
}

class Message
{
  // String? id;
  String? senderId;
  String? date;
  String? text;


  Message({required this.senderId, required this.date, required this.text});

  Message.fromJson(Map<String,dynamic>json)
  {
    try
    {
      senderId=json['sender'];
      // id=json['_id'];
      date=json['date'];
      text=json['text'];
    }
    catch (e,stackTrace)
    {
      print('ERROR IN MESSAGE MODEL, ${e.toString()}, $stackTrace');
    }
  }
}