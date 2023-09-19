import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePersonalPhoto extends StatelessWidget {
  const ChangePersonalPhoto({super.key});

  static const List<Map<String,String>> list= [
    {
      'name':'avatar1.png',
      'link':'assets/images/avatar1.png'
    },

    {
      'name':'avatar2.png',
      'link':'assets/images/avatar2.png'
    },

    {
      'name':'avatar3.png',
      'link':'assets/images/avatar3.png'
    },

    {
      'name':'avatar4.png',
      'link':'assets/images/avatar4.png'
    },

    {
      'name':'avatar5.png',
      'link':'assets/images/avatar5.png'
    },

    {
      'name':'avatar6.png',
      'link':'assets/images/avatar6.png'
    },

    {
      'name':'avatar7.png',
      'link':'assets/images/avatar7.png'
    },

    {
      'name':'avatar8.png',
      'link':'assets/images/avatar8.png'
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
                  'Choose a Photo',
                  style:TextStyle(
                      color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                      fontFamily: 'WithoutSans',
                      fontWeight: FontWeight.w600
                  ),
                )
            ),
            body: SingleChildScrollView(
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
