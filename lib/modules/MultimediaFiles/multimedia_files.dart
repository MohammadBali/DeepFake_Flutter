import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../layout/cubit/cubit.dart';
import '../../shared/components/Localization/Localization.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../InquiryDetails/InquiryDetails.dart';

class MultimediaFiles extends StatefulWidget {
  const MultimediaFiles({super.key});

  @override
  State<MultimediaFiles> createState() => _MultimediaFilesState();
}

class _MultimediaFilesState extends State<MultimediaFiles> {

  String? currentMultimediaType=Localization.translate('audio_choose_file_option');

  @override
  void initState()
  {
    currentMultimediaType=Localization.translate('audio_choose_file_option');
    super.initState();
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {
          //if Uploading Audio and Getting results back is a success AND the uploadedAudioInquiryModel isn't NULL => Show Prompt to inspect the data.
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


          //if Uploading Image and Getting results back is a success AND the uploadedImageInquiryModel isn't NULL => Show Prompt to inspect the data.
          if(state is AppUploadImageInquirySuccessState && AppCubit.get(context).uploadedImageInquiryModel !=null)
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
                                      return navigateTo(context, InquiryDetails(inquiry: AppCubit.get(context).uploadedImageInquiryModel! ));
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
                              currentMultimediaType == Localization.translate('audio_choose_file_option')? Localization.translate('audio_title') : Localization.translate('image_title'),
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
                          currentMultimediaType == Localization.translate('audio_choose_file_option')? Localization.translate('audio_second_title'): Localization.translate('image_second_title') ,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              wordSpacing: 2
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                        ),

                        const SizedBox(height: 25,),

                        Align(
                          alignment: AlignmentDirectional.center,
                          child: defaultBox(
                            cubit: cubit,
                            boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                            borderColor: cubit.isDarkTheme? defaultDarkColor: defaultColor,
                            manualBorderColor: true,
                            paddingOptions: false,
                            padding: 0,

                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                              [
                                GestureDetector(
                                  onTap: ()
                                  {
                                    setState(() {
                                      currentMultimediaType=Localization.translate('audio_choose_file_option');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: Icon(
                                      Icons.audiotrack_rounded,
                                      color: currentMultimediaType == Localization.translate('audio_choose_file_option')
                                          ? cubit.isDarkTheme? defaultDarkColor : defaultColor
                                          : cubit.isDarkTheme? Colors.white : defaultHomeColor,
                                    ),
                                  ),
                                ),

                                Text(
                                  '|',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,

                                  ),
                                ),

                                GestureDetector(
                                  onTap: ()
                                  {
                                    setState(() {
                                      currentMultimediaType=Localization.translate('image_choose_file_option');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: Icon(
                                      Icons.image_rounded,
                                      color: currentMultimediaType == Localization.translate('image_choose_file_option')
                                          ? cubit.isDarkTheme? defaultDarkColor : defaultColor
                                          : cubit.isDarkTheme? Colors.white : defaultHomeColor,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            onTap: (){},
                          ),
                        ),

                        const SizedBox(height: 25,),

                        ConditionalBuilder(
                            condition: currentMultimediaType == Localization.translate('audio_choose_file_option'),

                            //Audio File
                            builder: (context)=>Expanded(
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

                            //Image File
                            fallback: (context)=>Expanded(
                              child: Center(
                                child: cubit.chosenImageFile ==null ? SizedBox(
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
                                      cubit.pickImageFile();
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
                                              cubit.chosenImageFile!.name.capitalize!,
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
                                            condition: cubit.chosenImageFile !=null,

                                            fallback: (context)=> const Icon(Icons.image_rounded),

                                            builder: (context)=>GestureDetector(
                                              child: const Icon(Icons.remove, color: Colors.redAccent,),
                                              onTap: ()
                                              {
                                                cubit.removeImageFile();
                                              },
                                            ),
                                          ),
                                        ],


                                      ),
                                      onTap: ()
                                      async {
                                        openFile(cubit.chosenImageFile!.path!);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ),

                        const SizedBox(height: 10,),

                        Center(
                          child: ConditionalBuilder(
                            condition: state is! AppUploadAudioInquiryLoadingState || state is! AppUploadImageInquiryLoadingState,

                            fallback: (context)=>defaultProgressIndicator(context),

                            builder:(context)=> defaultButton(
                              title: Localization.translate('upload_button'),
                              color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                              onTap: ()
                              async
                              {
                                //Check if Audio screen is on
                                if(currentMultimediaType == Localization.translate('audio_choose_file_option'))
                                  {
                                    if(cubit.chosenAudioFile!=null)
                                    {
                                      if(allowedAudioTypes.contains(cubit.chosenAudioFile!.extension))
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
                                          defaultToast(msg: Localization.translate('text_wrong_file'));
                                        }
                                    }


                                    else
                                    {
                                      defaultToast(msg: Localization.translate('upload_audio_no_data_toast'));
                                    }
                                  }

                                //Image Screen is on
                                else
                                  {
                                    if(cubit.chosenImageFile!=null)
                                    {
                                      if(allowedImageTypes.contains(cubit.chosenImageFile!.extension))
                                        {
                                          cubit.uploadImageInquiry(

                                            file:cubit.chosenImageFile!,

                                            onSendProgress: (int sent, int total)
                                            {
                                              print('File is Being Uploaded: Sent:$sent Total:$total');
                                            },

                                          ).then((value)
                                          {
                                            cubit.removeImageFile();

                                          }).catchError((error)
                                          {
                                            defaultToast(msg: error.toString());
                                          });
                                        }

                                      else
                                      {
                                        defaultToast(msg: Localization.translate('text_wrong_file'));
                                      }

                                    }

                                    else
                                    {
                                      defaultToast(msg: Localization.translate('upload_image_no_data_toast'));
                                    }
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
                                currentMultimediaType == Localization.translate('audio_choose_file_option')? Localization.translate('audio_title') : Localization.translate('image_title'),
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
                            currentMultimediaType == Localization.translate('audio_choose_file_option')? Localization.translate('audio_second_title'): Localization.translate('image_second_title') ,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                wordSpacing: 2
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,

                          ),

                          const SizedBox(height: 25,),

                          Align(
                            alignment: AlignmentDirectional.center,
                            child: defaultBox(
                              cubit: cubit,
                              boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                              borderColor: cubit.isDarkTheme? defaultDarkColor: defaultColor,
                              manualBorderColor: true,
                              paddingOptions: false,
                              padding: 0,

                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:
                                [
                                  GestureDetector(
                                    onTap: ()
                                    {
                                      setState(() {
                                        currentMultimediaType=Localization.translate('audio_choose_file_option');
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: Icon(
                                        Icons.audiotrack_rounded,
                                        color: currentMultimediaType == Localization.translate('audio_choose_file_option')
                                            ? cubit.isDarkTheme? defaultDarkColor : defaultColor
                                            : cubit.isDarkTheme? Colors.white : defaultHomeColor,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    '|',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,

                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: ()
                                    {
                                      setState(() {
                                        currentMultimediaType=Localization.translate('image_choose_file_option');
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: Icon(
                                        Icons.image_rounded,
                                        color: currentMultimediaType == Localization.translate('image_choose_file_option')
                                            ? cubit.isDarkTheme? defaultDarkColor : defaultColor
                                            : cubit.isDarkTheme? Colors.white : defaultHomeColor,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              onTap: (){},
                            ),
                          ),

                          const SizedBox(height: 25,),

                          ConditionalBuilder(
                            condition: currentMultimediaType == Localization.translate('audio_choose_file_option'),

                            //Audio File
                            builder: (context)=>Center(
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

                            //Image File
                            fallback: (context)=>Center(
                              child: cubit.chosenImageFile ==null ? SizedBox(
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
                                    cubit.pickImageFile();
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
                                            cubit.chosenImageFile!.name.capitalize!,
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
                                          condition: cubit.chosenImageFile !=null,

                                          fallback: (context)=> const Icon(Icons.image_rounded),

                                          builder: (context)=>GestureDetector(
                                            child: const Icon(Icons.remove, color: Colors.redAccent,),
                                            onTap: ()
                                            {
                                              cubit.removeImageFile();
                                            },
                                          ),
                                        ),
                                      ],


                                    ),
                                    onTap: ()
                                    async {
                                      openFile(cubit.chosenImageFile!.path!);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 50,),

                          Center(
                            child: ConditionalBuilder(
                              condition: state is! AppUploadAudioInquiryLoadingState || state is! AppUploadImageInquiryLoadingState,

                              fallback: (context)=>defaultProgressIndicator(context),

                              builder:(context)=> defaultButton(
                                title: Localization.translate('upload_button'),
                                color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                onTap: ()
                                async
                                {
                                  //Check if Audio screen is on
                                  if(currentMultimediaType == Localization.translate('audio_choose_file_option'))
                                  {
                                    if(cubit.chosenAudioFile!=null)
                                    {
                                      if(allowedAudioTypes.contains(cubit.chosenAudioFile!.extension))
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
                                        defaultToast(msg: Localization.translate('text_wrong_file'));
                                      }
                                    }


                                    else
                                    {
                                      defaultToast(msg: Localization.translate('upload_audio_no_data_toast'));
                                    }
                                  }

                                  //Image Screen is on
                                  else
                                  {
                                    if(cubit.chosenImageFile!=null)
                                    {
                                      if(allowedImageTypes.contains(cubit.chosenImageFile!.extension))
                                      {
                                        cubit.uploadImageInquiry(

                                          file:cubit.chosenImageFile!,

                                          onSendProgress: (int sent, int total)
                                          {
                                            print('File is Being Uploaded: Sent:$sent Total:$total');
                                          },

                                        ).then((value)
                                        {
                                          cubit.removeImageFile();

                                        }).catchError((error)
                                        {
                                          defaultToast(msg: error.toString());
                                        });
                                      }

                                      else
                                      {
                                        defaultToast(msg: Localization.translate('text_wrong_file'));
                                      }

                                    }

                                    else
                                    {
                                      defaultToast(msg: Localization.translate('upload_image_no_data_toast'));
                                    }
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
