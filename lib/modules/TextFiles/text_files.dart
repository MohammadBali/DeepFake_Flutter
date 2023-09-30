import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/InquiryDetails/InquiryDetails.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_extensions/string_extensions.dart';

class TextFiles extends StatelessWidget {
  const TextFiles({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {
        //if Uploading Text and Getting results back is a success AND the uploadedTextInquiryModel isn't NULL => Show Prompt to inspect the data.
        if(state is AppUploadTextInquirySuccessState && AppCubit.get(context).uploadedTextInquiryModel !=null)
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
                                      return navigateTo(context, InquiryDetails(inquiry: AppCubit.get(context).uploadedTextInquiryModel! ));
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
        var cubit=AppCubit.get(context);

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

                        Expanded(
                          child: Center(
                            child: cubit.chosenFile ==null ? SizedBox(
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
                                  cubit.pickFile();
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
                                          cubit.chosenFile!.name.capitalize!,
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
                                        condition: cubit.chosenFile !=null,

                                        fallback: (context)=> const Icon(Icons.folder_open_rounded),

                                        builder: (context)=>GestureDetector(
                                          child: const Icon(Icons.remove, color: Colors.redAccent,),
                                          onTap: ()
                                          {
                                            cubit.removeFile();
                                          },
                                        ),
                                      ),
                                    ],


                                  ),
                                  onTap: ()
                                  async {
                                    openFile(cubit.chosenFile!.path!);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10,),

                        Center(
                          child: ConditionalBuilder(
                            condition: state is! AppUploadTextInquiryLoadingState,

                            fallback: (context)=>defaultProgressIndicator(context),

                            builder:(context)=> defaultButton(
                              title: Localization.translate('upload_button'),
                              color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                              onTap: ()
                              {
                                if(cubit.chosenFile!=null)
                                {

                                  cubit.uploadTextInquiry(

                                  file:cubit.chosenFile!,

                                  onSendProgress: (int sent, int total)
                                  {
                                    print('File is Being Uploaded: Sent:$sent Total:$total');
                                  },

                                  ).then((value)
                                  {
                                    cubit.removeFile();

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

                                // const Spacer(),
                                //
                                // Visibility(
                                //   visible: cubit.chosenFile !=null,
                                //   child: IconButton(
                                //       onPressed: ()
                                //       {
                                //         cubit.removeFile();
                                //       },
                                //       icon: Icon(
                                //         Icons.remove,
                                //         color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                //
                                //       )
                                //   ),
                                // ),
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

                            const SizedBox(height: 100,),

                            Center(
                              child: cubit.chosenFile ==null ? SizedBox(
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
                                    cubit.pickFile();
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
                                            cubit.chosenFile!.name.capitalize!,
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
                                          condition: cubit.chosenFile !=null,

                                          fallback: (context)=> const Icon(Icons.folder_open_rounded),

                                          builder: (context)=>GestureDetector(
                                            child: const Icon(Icons.remove, color: Colors.redAccent,),
                                            onTap: ()
                                            {
                                              cubit.removeFile();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: ()
                                    async {
                                      openFile(cubit.chosenFile!.path!);
                                    },
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 75,),

                            Center(
                              child: ConditionalBuilder(
                                condition: state is! AppUploadTextInquiryLoadingState,

                                fallback: (context)=>defaultProgressIndicator(context),

                                builder: (context)=>defaultButton(
                                  title: Localization.translate('upload_button'),
                                  color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                  onTap: ()
                                  {
                                    if(cubit.chosenFile!=null)
                                    {

                                      cubit.uploadTextInquiry(

                                        file:cubit.chosenFile!,

                                        onSendProgress: (int sent, int total)
                                        {
                                          print('File is Being Uploaded: Sent:$sent Total:$total');
                                        },

                                      ).then((value)
                                      {
                                        cubit.removeFile();

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
