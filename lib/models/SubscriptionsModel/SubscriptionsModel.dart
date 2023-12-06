class SubscriptionsModel
{
  List<Subscription>? subscriptions=[];

  SubscriptionsModel.fromJson(Map<String,dynamic>json)
  {
    json['subscriptions'].forEach((subscription)
    {
      subscriptions!.add(Subscription.fromJson(subscription));
    });
  }
}

class Subscription
{
  String? ownerId;
  String? subscriptionId;

  Subscription.fromJson(Map<String,dynamic>json)
  {
    try {
      ownerId=json['owner_id'];
      subscriptionId=json['_id'];
    }catch (e,stackTrace) {
      print('ERROR WHILE SETTING SUBSCRIPTION CLASS MODEL, ${e.toString()} $stackTrace');
    }
  }
}


// class Subscription
// {
//   String? ownerId;
//   String? subscriptionId;
//   String? photo;
//   String? name;
//   String? lastName;
//
//   Subscription.fromJson(Map<String,dynamic>json)
//   {
//     try {
//       ownerId=json['owner_id']['_id'];
//       subscriptionId=json['_id'];
//
//       name=json['owner_id']['name'];
//       lastName=json['owner_id']['last_name'];
//       photo=json['owner_id']['photo'];
//
//     }catch (e,stackTrace) {
//       print('ERROR WHILE SETTING SUBSCRIPTION CLASS MODEL, ${e.toString()} $stackTrace');
//     }
//   }
// }
