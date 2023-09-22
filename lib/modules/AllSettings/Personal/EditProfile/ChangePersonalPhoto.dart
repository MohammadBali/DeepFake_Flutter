import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePersonalPhoto extends StatelessWidget {
  const ChangePersonalPhoto({super.key});

  static const List<Map<String,String>> list= [
    {
      'name':'geometric_1.jpg',
      'link':'assets/images/geometric_1.jpg'
    },

    {
      'name':'geometric_2.jpg',
      'link':'assets/images/geometric_2.jpg'
    },

    {
      'name':'geometric_3.jpg',
      'link':'assets/images/geometric_3.jpg'
    },

    {
      'name':'man_1.jpg',
      'link':'assets/images/man_1.jpg'
    },

    {
      'name':'man_2.jpg',
      'link':'assets/images/man_2.jpg'
    },

    {
      'name':'others_1.jpg',
      'link':'assets/images/others_1.jpg'
    },

    {
      'name':'others_2.jpg',
      'link':'assets/images/others_2.jpg'
    },

    {
      'name':'robot_1.jpg',
      'link':'assets/images/robot_1.jpg'
    },

    {
      'name':'robot_2.jpg',
      'link':'assets/images/robot_2.jpg'
    },

    {
      'name':'woman_1.jpg',
      'link':'assets/images/woman_1.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit= AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
                title: Text(
                  Localization.translate('appBar_title_choose_photo'),
                  style:TextStyle(
                      color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                      fontFamily: 'WithoutSans',
                      fontWeight: FontWeight.w600
                  ),
                )
            ),
            body: Directionality(
              textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children:
                    [
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 25,
                        crossAxisSpacing: 25,
                        childAspectRatio: 1.19,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                            list.length,
                                (index) => itemBuilder(cubit, list[index])
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  Widget itemBuilder(AppCubit cubit, Map image)
  {
    return Column(
      children: [
        InkWell(
          highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          child: CircleAvatar(
            backgroundColor: Colors.black12,
            radius: 60,
            backgroundImage: AssetImage(image['link']),

          ),
          onTap: () //Change User's profile picture.
          {
            cubit.updateUserProfile(
              photo: image['name'],
              name: null,
              email: null,
            );
          },
        ),

        const SizedBox(height: 5,),
        myDivider(),
      ],
    );
  }
}
