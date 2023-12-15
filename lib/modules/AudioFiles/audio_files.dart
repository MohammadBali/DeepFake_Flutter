import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../layout/cubit/cubit.dart';
import '../../shared/components/Localization/Localization.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../InquiryDetails/InquiryDetails.dart';

class AudioFiles extends StatelessWidget {
  const AudioFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {
          //if Uploading Text and Getting results back is a success AND the uploadedTextInquiryModel isn't NULL => Show Prompt to inspect the data.
          if(state is AppUploadAudioInquirySuccessState && AppCubit.get(context).uploadedAudioInquiryModel !=null)
          {
            showDialog(
                context: context,
                builder: (dialogContext)
                {
                  return defaultAlertDialog(
                      context: dialogContext,
                      title: Localization.translate('upload_text_inquiry_title_alert'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:
                          [
                            Text(Localization.translate('upload_text_inquiry_secondary_alert')),

                            const SizedBox(height: 5,),

                            Row(
                              children:
                              [
                                TextButton(
                                    onPressed: ()
                                    {
                                      Navigator.of(dialogContext).pop(true);
                                      return navigateTo(context, InquiryDetails(inquiry: AppCubit.get(context).uploadedAudioInquiryModel! ));
                                    },
                                    child: Text(Localization.translate('exit_app_yes'))
                                ),

                                const Spacer(),

                                TextButton(
                                  onPressed: ()=> Navigator.of(dialogContext).pop(false),
                                  child: Text(Localization.translate('exit_app_no')),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ));
                }
            );
          }
        },
        builder: (context,state)
        {
          var cubit= AppCubit.get(context);

          return OrientationBuilder(
            builder: (context,orientation)
            {
              if(orientation == Orientation.portrait)
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
                              Localization.translate('audio_title'),
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
                          Localization.translate('audio_second_title'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              wordSpacing: 2
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                        ),

                        const SizedBox(height: 50,),

                        Expanded(
                          child: Center(
                            child: cubit.chosenAudioFile ==null ? SizedBox(
                              height: MediaQuery.of(context).size.height /5,
                              width: MediaQuery.of(context).size.width /2,
                              child: defaultBox(
                                cubit: cubit,
                                boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor.withOpacity(0.9) : defaultSecondaryColor.withOpacity(0.9),
                                manualBorderColor: true,
                                child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 35,
                                    )
                                ),
                                onTap: ()
                                {
                                  cubit.pickAudioFile();
                                },
                              ),
                            ) :
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
                              child: SizedBox(
                                child: defaultBox(
                                  padding: 28,
                                  cubit: cubit,
                                  boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children:
                                    [
                                      Expanded(
                                        child: Text(
                                          cubit.chosenAudioFile!.name.capitalize!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: cubit.isDarkTheme? defaultSecondaryDarkColor : Colors.white,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      const SizedBox(width: 5,),

                                      ConditionalBuilder(
                                        condition: cubit.chosenAudioFile !=null,

                                        fallback: (context)=> const Icon(Icons.audiotrack_rounded),

                                        builder: (context)=>GestureDetector(
                                          child: const Icon(Icons.remove, color: Colors.redAccent,),
                                          onTap: ()
                                          {
                                            cubit.removeAudioFile();
                                          },
                                        ),
                                      ),
                                    ],


                                  ),
                                  onTap: ()
                                  async {
                                    openFile(cubit.chosenAudioFile!.path!);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10,),

                        Center(
                          child: ConditionalBuilder(
                            condition: state is! AppUploadAudioInquiryLoadingState,

                            fallback: (context)=>defaultProgressIndicator(context),

                            builder:(context)=> defaultButton(
                              title: Localization.translate('upload_button'),
                              color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                              onTap: ()
                              async
                              {
                                if(cubit.chosenAudioFile!=null)
                                {

                                  cubit.uploadAudioInquiry(

                                    file:cubit.chosenAudioFile!,

                                    onSendProgress: (int sent, int total)
                                    {
                                      print('File is Being Uploaded: Sent:$sent Total:$total');
                                    },

                                  ).then((value)
                                  {
                                    cubit.removeAudioFile();

                                  }).catchError((error)
                                  {
                                    defaultToast(msg: error.toString());
                                  });
                                }

                                else
                                {
                                  defaultToast(msg: Localization.translate('upload_audio_no_data_toast'));
                                }
                              },
                              textColor: cubit.isDarkTheme? Colors.black : Colors.white,
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                }

              else
                {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          Row(
                            children: [
                              Text(
                                Localization.translate('audio_title'),
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
                            Localization.translate('audio_second_title'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                wordSpacing: 2
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,

                          ),

                          const SizedBox(height: 25,),

                          Center(
                            child: cubit.chosenAudioFile ==null ? SizedBox(
                              height: MediaQuery.of(context).size.height /5,
                              width: MediaQuery.of(context).size.width /2,
                              child: defaultBox(
                                cubit: cubit,
                                boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor.withOpacity(0.9) : defaultSecondaryColor.withOpacity(0.9),
                                manualBorderColor: true,
                                child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 35,
                                    )
                                ),
                                onTap: ()
                                {
                                  cubit.pickAudioFile();
                                },
                              ),
                            ) :
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
                              child: SizedBox(
                                child: defaultBox(
                                  padding: 28,
                                  cubit: cubit,
                                  boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children:
                                    [
                                      Expanded(
                                        child: Text(
                                          cubit.chosenAudioFile!.name.capitalize!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: cubit.isDarkTheme? defaultSecondaryDarkColor : Colors.white,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      const SizedBox(width: 5,),

                                      ConditionalBuilder(
                                        condition: cubit.chosenAudioFile !=null,

                                        fallback: (context)=> const Icon(Icons.audiotrack_rounded),

                                        builder: (context)=>GestureDetector(
                                          child: const Icon(Icons.remove, color: Colors.redAccent,),
                                          onTap: ()
                                          {
                                            cubit.removeAudioFile();
                                          },
                                        ),
                                      ),
                                    ],


                                  ),
                                  onTap: ()
                                  async {
                                    openFile(cubit.chosenAudioFile!.path!);
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 50,),

                          Center(
                            child: ConditionalBuilder(
                              condition: state is! AppUploadTextInquiryLoadingState,

                              fallback: (context)=>defaultProgressIndicator(context),

                              builder: (context)=>defaultButton(
                                title: Localization.translate('upload_button'),
                                color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                onTap: ()
                                {
                                  if(cubit.chosenTextFile!=null)
                                  {

                                    cubit.uploadTextInquiry(

                                      file:cubit.chosenTextFile!,

                                      onSendProgress: (int sent, int total)
                                      {
                                        print('File is Being Uploaded: Sent:$sent Total:$total');
                                      },

                                    ).then((value)
                                    {
                                      cubit.removeTextFile();

                                    }).catchError((error)
                                    {
                                      defaultToast(msg: error.toString());
                                    });
                                  }
                                  else
                                  {
                                    defaultToast(msg: Localization.translate('upload_text_no_data_toast'));
                                  }
                                },
                                textColor: cubit.isDarkTheme? Colors.black : Colors.white,
                              ),
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
