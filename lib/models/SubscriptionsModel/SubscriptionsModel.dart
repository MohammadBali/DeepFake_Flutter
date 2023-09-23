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