import 'package:deepfake_detection/models/UserDataModel/UserDataModel.dart';

class SubscriptionsDetailsModel
{
  List<SubscriptionDetails>? subscriptions=[];

  SubscriptionsDetailsModel.fromJson(Map<String,dynamic>json)
  {
    json['subscriptions'].forEach((subscription)
    {
      subscriptions!.add(SubscriptionDetails.fromJson(subscription));
    });
  }

}


class SubscriptionDetails
{
  UserData? owner;
  String? subscriptionId;

  SubscriptionDetails.fromJson(Map<String,dynamic>json)
  {
    try {
      owner= UserData.fromJson(json['owner_id']);
      subscriptionId=json['_id'];
    }catch (e,stackTrace) {
      print('ERROR WHILE SETTING SUBSCRIPTION DETAILS CLASS MODEL, ${e.toString()} $stackTrace');
    }
  }
}
