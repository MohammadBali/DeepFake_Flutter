import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/MessageModel/MessageModel.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/styles/colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController textEditingController= TextEditingController();

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit= AppCubit.get(context);

        return Directionality(
          textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
          child: OrientationBuilder(
            builder: (context,orientation)
            {
              return Scaffold(
                resizeToAvoidBottomInset: orientation == Orientation.portrait ? true : false,

                appBar: AppBar(
                  title: Text(
                    Localization.translate('chat_screen_appBar'),
                    style: TextStyle(
                        color: cubit.isDarkTheme? defaultDarkFontColor: defaultFontColor,
                        fontFamily: 'WithoutSans',
                        fontWeight: FontWeight.w600
                    ),
                  ),

                  actions:
                  [
                    //Allow to clear messages
                    Visibility(
                      visible: cubit.messageModel!.messages!.isNotEmpty,
                      child: IconButton(
                        onPressed: ()
                        {
                          showDialog(
                            context: context,
                            builder: (dialogContext)
                            {
                              return defaultAlertDialog(
                                context: dialogContext,
                                title: Localization.translate('chat_screen_delete_messages'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                    [
                                      Text(Localization.translate('chat_screen_delete_body1')),

                                      const SizedBox(height: 5,),

                                      Row(
                                        children:
                                        [
                                          TextButton(
                                              onPressed: ()
                                              {
                                                cubit.removeMessages();
                                                Navigator.of(dialogContext).pop(false);
                                              },
                                              child: Text(Localization.translate('exit_app_yes'))
                                          ),

                                          const Spacer(),

                                          TextButton(
                                            onPressed: ()=> Navigator.of(dialogContext).pop(false),
                                            child: Text(Localization.translate('exit_app_no')),
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.remove, color: defaultRedColor,),
                      ),
                    ),
                  ],
                ),

                body: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children:
                    [
                      Expanded(
                        child: ConditionalBuilder(
                          condition: cubit.messageModel!.messages!.isNotEmpty,

                          fallback: (context)=> Text(
                            Localization.translate('chat_screen_no_text_title'),
                            style: TextStyle(
                              color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                              fontSize: 18,

                            ),
                          ),

                          builder: (context)=>ListView.separated(
                            shrinkWrap: true,

                            itemBuilder: (context,index)
                            {

                              if(cubit.messageModel!.messages![index].senderId! == AppCubit.userData!.id!)
                              {
                                return myMessageBuilder(message: cubit.messageModel!.messages![index], cubit: cubit);
                              }
                              else
                              {
                                return responseMessageBuilder(message: cubit.messageModel!.messages![index], cubit: cubit);
                              }
                            },

                            separatorBuilder: (context,index)=> const SizedBox(height: 5,),

                            itemCount: cubit.messageModel!.messages!.length,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25,),

                      Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: cubit.isDarkTheme? Colors.grey[300]! : Colors.grey
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            children:
                            [
                              Expanded(
                                child: TextFormField(
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    hintText: Localization.translate('chat_screen_tff'),
                                    hintStyle: TextStyle(
                                        color: cubit.isDarkTheme? Colors.white : Colors.black
                                    ),

                                  ),

                                  onFieldSubmitted: (value)
                                  {
                                    if(textEditingController.text.isNotEmpty)
                                    {
                                      cubit.addMessage(textEditingController.text);

                                      textEditingController.text='';
                                    }
                                  },
                                ),
                              ),

                              MaterialButton(
                                onPressed: ()
                                {
                                  if(textEditingController.text.isNotEmpty)
                                  {
                                    cubit.addMessage(textEditingController.text);

                                    //cubit.sendMessage(textEditingController.text);

                                    textEditingController.text='';
                                  }

                                  else
                                  {
                                    defaultToast(msg: 'No Data to Send');
                                  }
                                },
                                minWidth: 1.0,
                                child: Icon(
                                  Icons.send,
                                  color: cubit.isDarkTheme? Colors.white : Colors.black,
                                  size: 16.0,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  //My Message item builder, written by user
  Widget myMessageBuilder({ Message? message, required AppCubit cubit})
  {
    //print('Data is: ${message!.text}, ${message!.senderId}, ${message!.date}');
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
          borderRadius: const BorderRadiusDirectional.only(
            topEnd: Radius.circular(10.0),
            bottomEnd: Radius.circular(10.0),
            bottomStart: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
          ),
        ),
        child: Text(
          message!.text!,
          style: TextStyle(
              color: cubit.isDarkTheme? Colors.black : Colors.white
          ),
        ),
      ),
    );
  }

  //Response from AI item builder
  Widget responseMessageBuilder({ Message? message, required AppCubit cubit})
  {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: cubit.isDarkTheme? defaultRespondMessageDarkColor : defaultRespondMessageColor,
          borderRadius: const BorderRadiusDirectional.only(
            topEnd: Radius.circular(10.0),
            bottomEnd: Radius.circular(10.0),
            bottomStart: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
          ),
        ),
        child: Text(
          message!.text!,
          style: TextStyle(
              color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor
          ),
        ),
      ),
    );
  }
}
