import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
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
        return Directionality(
          textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                Localization.translate('appearance_profile'),
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

                        Text(
                          Localization.translate('dark_mode_appearance'),
                          style: const TextStyle(
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
          ),
        );
      },
    );
  }
}
