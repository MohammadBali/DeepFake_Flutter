import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Appearance extends StatelessWidget {
  const Appearance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},

      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Appearance',
              style:TextStyle(
                  color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                  fontFamily: 'WithoutSans',
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children:
                [
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
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