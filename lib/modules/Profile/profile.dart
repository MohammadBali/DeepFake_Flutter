import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/AllSettings/General/Appearance/appearance.dart';
import 'package:deepfake_detection/modules/AllSettings/Personal/EditProfile/editProfile.dart';
import 'package:deepfake_detection/modules/AllSettings/Personal/PreviousInquiries/UserInquiries.dart';
import 'package:deepfake_detection/modules/AllSettings/Personal/YourPosts/UserPosts.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../AllSettings/General/GeneralSettings/GeneralSettings.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        return OrientationBuilder(
            builder: (context,orientation)
                {
                  if(orientation == Orientation.portrait)
                    {
                      return Padding(
                        padding: const EdgeInsets.all(42.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                          [
                            defaultBox(
                                padding: 15,
                                paddingOptions: false,
                                cubit: cubit,
                                boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                child: Column(
                                  children:
                                  [
                                    itemBuilder(
                                        icon: Icons.person_outline_rounded,
                                        text: Localization.translate('edit_profile_profile'),
                                        onTap: ()
                                        {
                                          navigateTo(context, EditProfile());
                                        }
                                    ),

                                    const SizedBox(height: 5),

                                    myDivider(color: Colors.white),

                                    itemBuilder(
                                        icon: Icons.favorite_border_outlined,
                                        text: Localization.translate('your_posts_profile'),
                                        onTap: ()
                                        {
                                          navigateTo(context, const UserPosts());
                                        }
                                    ),

                                    const SizedBox(height: 5),

                                    myDivider(color: Colors.white),

                                    itemBuilder(
                                        icon: Icons.timelapse_rounded,
                                        text: Localization.translate('previous_inquiries_profile'),
                                        onTap: ()
                                        {
                                          navigateTo(context, const UserInquiries());
                                        }
                                    ),
                                  ],
                                ),
                                onTap: (){},
                                manualBorderColor: true,
                                borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor
                            ),

                            const SizedBox(height: 20,),

                            defaultBox(
                                padding: 15,
                                paddingOptions: false,
                                cubit: cubit,
                                boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                child: Column(
                                  children:
                                  [
                                    itemBuilder(
                                        icon: Icons.light_outlined,
                                        text: Localization.translate('appearance_profile'),
                                        onTap: ()
                                        {
                                          navigateTo(context, const Appearance());
                                        }
                                    ),

                                    const SizedBox(height: 5),

                                    myDivider(color: Colors.white),

                                    itemBuilder(
                                        icon: Icons.settings_outlined,
                                        text: Localization.translate('general_settings_profile'),
                                        onTap: ()
                                        {
                                          navigateTo(context, GeneralSettings() );
                                        }
                                    ),

                                  ],
                                ),
                                onTap: (){},
                                manualBorderColor: true,
                                borderColor: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor
                            ),

                            const SizedBox(height: 20,),

                            defaultBox(
                              padding: 15,
                              paddingOptions: false,
                              cubit: cubit,
                              boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                              child: Column(
                                children:
                                [
                                  itemBuilder(
                                      icon: Icons.question_mark_outlined,
                                      text: Localization.translate('learn_more_profile'),
                                      onTap: ()
                                      {

                                      }
                                  ),

                                  const SizedBox(height: 5),

                                  myDivider(color: Colors.white),

                                  itemBuilder(
                                      icon: Icons.logout_outlined,
                                      text: Localization.translate('logout_profile'),
                                      onTap: ()
                                      {
                                        cubit.logout(context: context);
                                      }
                                  ),

                                ],
                              ),
                              onTap: ()
                              {},
                            ),
                          ],
                        ),
                      );
                    }

                  else
                    {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(42.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:
                            [
                              defaultBox(
                                  padding: 15,
                                  paddingOptions: false,
                                  cubit: cubit,
                                  boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  child: Column(
                                    children:
                                    [
                                      itemBuilder(
                                          icon: Icons.person_outline_rounded,
                                          text: Localization.translate('edit_profile_profile'),
                                          onTap: ()
                                          {
                                            navigateTo(context, EditProfile());
                                          }
                                      ),

                                      const SizedBox(height: 5),

                                      myDivider(color: Colors.white),

                                      itemBuilder(
                                          icon: Icons.favorite_border_outlined,
                                          text: Localization.translate('your_posts_profile'),
                                          onTap: ()
                                          {
                                            navigateTo(context, const UserPosts());
                                          }
                                      ),

                                      const SizedBox(height: 5),

                                      myDivider(color: Colors.white),

                                      itemBuilder(
                                          icon: Icons.timelapse_rounded,
                                          text: Localization.translate('previous_inquiries_profile'),
                                          onTap: ()
                                          {
                                            navigateTo(context, const UserInquiries());
                                          }
                                      ),
                                    ],
                                  ),
                                  onTap: (){},
                                  manualBorderColor: true,
                                  borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor
                              ),

                              const SizedBox(height: 20,),

                              defaultBox(
                                  padding: 15,
                                  paddingOptions: false,
                                  cubit: cubit,
                                  boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  child: Column(
                                    children:
                                    [
                                      itemBuilder(
                                          icon: Icons.light_outlined,
                                          text: Localization.translate('appearance_profile'),
                                          onTap: ()
                                          {
                                            navigateTo(context, const Appearance());
                                          }
                                      ),

                                      const SizedBox(height: 5),

                                      myDivider(color: Colors.white),

                                      itemBuilder(
                                          icon: Icons.settings_outlined,
                                          text: Localization.translate('general_settings_profile'),
                                          onTap: ()
                                          {

                                          }
                                      ),

                                    ],
                                  ),
                                  onTap: (){},
                                  manualBorderColor: true,
                                  borderColor: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor
                              ),


                              const SizedBox(height: 20,),

                              defaultBox(
                                padding: 15,
                                paddingOptions: false,
                                cubit: cubit,
                                boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                child: Column(
                                  children:
                                  [
                                    itemBuilder(
                                        icon: Icons.question_mark_outlined,
                                        text: Localization.translate('learn_more_profile'),
                                        onTap: ()
                                        {

                                        }
                                    ),

                                    const SizedBox(height: 5),

                                    myDivider(color: Colors.white),

                                    itemBuilder(
                                        icon: Icons.logout_outlined,
                                        text: Localization.translate('logout_profile'),
                                        onTap: ()
                                        {
                                          cubit.logout(context: context);
                                        }
                                    ),

                                  ],
                                ),
                                onTap: ()
                                {},
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                }
        );
      },
    );
  }

  Widget itemBuilder({required IconData icon, required String text, required void Function()? onTap}) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children:
    [
      Icon(icon),

      Expanded(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 15.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'GabrielSans',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),

      //const Spacer(),

      Align(
        alignment: AlignmentDirectional.topEnd,
        child: IconButton(
          onPressed: onTap,
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
          ),
          iconSize: 20,
        ),
      ),
    ],
  );
}
