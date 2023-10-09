import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/ChatBot/chatScreen.dart';
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

                            const SizedBox(height: 10,),

                            Image(
                              image: cubit.isDarkTheme? const AssetImage('assets/images/chatbot/chatbot_dark.png') : const AssetImage('assets/images/chatbot/chatbot_light.png'),
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              alignment: AlignmentDirectional.center,

                            ),

                            const SizedBox(height: 10,),

                            Center(
                              child: defaultButton(
                                title: Localization.translate('chat_bot_button'),
                                color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                onTap: ()
                                {
                                  if(AppCubit.userData !=null)
                                    {
                                      navigateTo(context, const ChatScreen());
                                    }
                                  else
                                    {
                                      defaultToast(msg: 'No Internet Connection');
                                    }
                                },
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

                              Image(
                                image: cubit.isDarkTheme? const AssetImage('assets/images/chatbot/chatbot_dark.png') : const AssetImage('assets/images/chatbot/chatbot_light.png'),
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,

                              ),


                              Center(
                                child: defaultButton(
                                  title: Localization.translate('chat_bot_button'),
                                  color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                  onTap: ()
                                  {
                                    if(AppCubit.userData !=null)
                                    {
                                      navigateTo(context, const ChatScreen());
                                    }
                                    else
                                    {
                                      defaultToast(msg: 'No Internet Connection');
                                    }
                                  },
                                  textColor: cubit.isDarkTheme? Colors.black : Colors.white,
                                ),
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
