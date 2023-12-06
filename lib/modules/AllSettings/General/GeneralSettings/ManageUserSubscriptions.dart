import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/SubscriptionsDetailsModel/SubscriptionsDetailsModel.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/components/Localization/Localization.dart';
import '../../../../shared/styles/colors.dart';
import '../../../AUserProfile/AUserProfile.dart';

class ManageUserSubscriptions extends StatelessWidget {
  const ManageUserSubscriptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit= AppCubit.get(context);

          return Directionality(
            textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(

              appBar: AppBar(
              title: Text(
                Localization.translate('manage_your_subscriptions_settings'),
                style:TextStyle(
                  color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                  fontFamily: 'WithoutSans',
                  fontWeight: FontWeight.w600),),
              ),

              body: RefreshIndicator(
                onRefresh: ()async
                {
                  return await Future(()=>cubit.getSubscriptionsDetails());
                },

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), //User can always scroll => can always fire the refresh indicator
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ConditionalBuilder(
                      condition: cubit.subscriptionsDetailsModel !=null && cubit.subscriptionsDetailsModel?.subscriptions!=null,
                      fallback: (context)=> Center(child: defaultProgressIndicator(context)),

                      builder: (context)=>ListView.separated(
                        itemBuilder: (context,index)=>itemBuilder(context: context, item: cubit.subscriptionsDetailsModel!.subscriptions![index], cubit: cubit),
                        separatorBuilder: (context,index)=>Column(
                          children:
                          [
                            const SizedBox(height: 20,),
                            myDivider(color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor),
                            const SizedBox(height: 20,),
                          ],
                        ),
                        itemCount: cubit.subscriptionsDetailsModel!.subscriptions!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
    );
  }

  Widget itemBuilder({required BuildContext context, required SubscriptionDetails item , required AppCubit cubit})=> InkWell(
    highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),

    onTap: ()
    {
      cubit.getAUserPosts(item.owner!.id!);
      navigateTo(context, AUserProfile(user: item.owner!));
    },

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children:
      [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile/${item.owner!.photo!}'),
          radius: 35,
        ),

        const Spacer(),

        Text(
          '${item.owner!.name!} ${item.owner!.lastName!}',
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const Spacer(),
      ],
    ),
  );
}
