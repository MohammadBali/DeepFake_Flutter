import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/Localization/Localization.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class ChatBot extends StatelessWidget {
  const ChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit= AppCubit.get(context);
          return OrientationBuilder(
            builder: (context,orientation)
              {
                  if(orientation==Orientation.portrait)
                    {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            Row(
                              children: [
                                Text(
                                  Localization.translate('chat_bot_title'),
                                  style: TextStyle(
                                    color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                    fontSize: 32,
                                    fontFamily: 'Neology',
                                  ),
                                ),

                              ],
                            ),

                            const SizedBox(height: 25,),

                            Text(
                              Localization.translate('chat_bot_secondary_title'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  wordSpacing: 2
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,

                            ),

                            const Spacer(),

                            Center(
                              child: defaultButton(
                                title: Localization.translate('chat_bot_button'),
                                color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                onTap: ()
                                {},
                                textColor: cubit.isDarkTheme? Colors.black : Colors.white,
                              ),
                            ),

                          ],
                        ),
                      );
                    }
                  
                  else
                    {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                            [
                              Row(
                                children: [
                                  Text(
                                    Localization.translate('text_title'),
                                    style: TextStyle(
                                      color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                      fontSize: 32,
                                      fontFamily: 'Neology',
                                    ),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 25,),

                              Text(
                                Localization.translate('text_second_title'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    wordSpacing: 2
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

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
}
