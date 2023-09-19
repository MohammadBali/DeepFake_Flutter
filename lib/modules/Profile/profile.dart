import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/AllSettings/General/Appearance/appearance.dart';
import 'package:deepfake_detection/modules/AllSettings/Personal/EditProfile/editProfile.dart';
import 'package:deepfake_detection/modules/AllSettings/Personal/PreviousInquiries/UserInquiries.dart';
import 'package:deepfake_detection/modules/AllSettings/Personal/YourPosts/UserPosts.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
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
                        text: 'Edit Profile',
                        onTap: ()
                        {
                          navigateTo(context, EditProfile());
                        }
                      ),

                      const SizedBox(height: 5),

                      myDivider(color: Colors.white),

                      itemBuilder(
                        icon: Icons.favorite_border_outlined,
                        text: 'Your Posts',
                        onTap: ()
                        {
                          navigateTo(context, const UserPosts());
                        }
                      ),

                      const SizedBox(height: 5),

                      myDivider(color: Colors.white),

                      itemBuilder(
                        icon: Icons.timelapse_rounded,
                        text: 'Previous Inquiries',
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
                            text: 'Appearance',
                            onTap: ()
                            {
                              navigateTo(context, const Appearance());
                            }
                        ),

                        const SizedBox(height: 5),

                        myDivider(color: Colors.white),

                        itemBuilder(
                            icon: Icons.settings_outlined,
                            text: 'General Settings',
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
                            text: 'Learn More',
                            onTap: ()
                            {

                            }
                        ),

                        const SizedBox(height: 5),

                        myDivider(color: Colors.white),

                        itemBuilder(
                            icon: Icons.logout_outlined,
                            text: 'Logout',
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


/*

                Row(
                  children:
                  [
                    Icon(
                      cubit.isDarkTheme? Icons.sunny : Icons.brightness_3_rounded,
                      size: 22,
                    ),

                    const SizedBox(width: 10,),

                    const Text(
                      'Dark Mode',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    ),

                    const Spacer(),

                    Switch(
                      value: cubit.isDarkTheme,
                      onChanged: (bool newValue)
                      {
                        cubit.changeTheme();
                      },
                      activeColor: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                      inactiveTrackColor: cubit.isDarkTheme? Colors.white: null,
                      activeTrackColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.5) : defaultColor.withOpacity(0.5),
                    ),
                  ],
                ),

                TextButton(
                  onPressed: ()
                  {
                    CacheHelper.saveData(key: 'token', value: '').then((value)
                    {
                      token='';
                      print('set token to zero');
                    });

                  },
                  child: const Text('Logout'),
                ),

 */