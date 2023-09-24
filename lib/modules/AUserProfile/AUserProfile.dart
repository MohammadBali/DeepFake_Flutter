import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/UserDataModel/UserDataModel.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class AUserProfile extends StatelessWidget {
  const AUserProfile({super.key, required this.user});

  final UserData user;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit= AppCubit.get(context);
        return WillPopScope(
          child: Directionality(
            textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  Localization.translate('appBar_title_a_user_profile'),
                  style: TextStyle(
                      color: cubit.isDarkTheme? defaultDarkFontColor: defaultFontColor,
                      fontFamily: 'WithoutSans',
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),

              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top:24.0, bottom: 24.0, end: 24.0),
                  child: Column(
                    children:
                    [
                      Row(
                        children:
                        [
                          Expanded(
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/images/profile/${user.photo!}'),
                              radius: 75,
                            ),
                          ),

                          Expanded(
                            child: Text(
                              '${user.name!} ${user.lastName!}',
                              style: const TextStyle(
                                fontFamily: 'Neology',
                                fontSize: 24,

                              ),
                            ),
                          ),
                        ],
                      ),

                      Visibility(
                        visible: AppCubit.userData!.id! != user.id!,
                        child: Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: TextButton(

                            child: Text(
                              isSubscribed(userId: user.id!, cubit: cubit)? Localization.translate('un_subscribe_a_user_profile') : Localization.translate('subscribe_a_user_profile') ,
                              style: TextStyle(
                                  color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                              ),
                            ),

                            onPressed: ()
                            {
                              cubit.manageSubscriptions(user.id!);

                              cubit.getSubscriptionsPosts();
                            },
                          ),
                        ),
                      ),


                      const SizedBox(height: 15,),

                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            myDivider(color: cubit.isDarkTheme? defaultDarkColor : defaultColor),

                            const SizedBox(height: 40,),

                            Text(
                              Localization.translate('shared_posts_a_user_profile'),
                              style: const TextStyle(
                                fontFamily: 'Neology',
                                fontSize: 26,

                              ),
                            ),

                            const SizedBox(height: 40,),

                            ConditionalBuilder(
                              condition: cubit.aUserPostsModel !=null,
                              fallback: (context)=>Center(child: defaultProgressIndicator(context),),
                              builder: (context)=>ListView.separated(
                                itemCount: cubit.aUserPostsModel!.posts!.length,
                                separatorBuilder: (context,index)=>const SizedBox(height: 25,),
                                itemBuilder: (context,index)=>postItemBuilder(cubit: cubit, post: cubit.aUserPostsModel!.posts![index], context: context, isPhotoClickable: false),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

          onWillPop: ()async
          {
            cubit.aUserPostsModel=null;
            return true;
          },
        );
      },
    );
  }
}


//aUserPostsModel