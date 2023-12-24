import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/InquiryDetails/InquiryDetails.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:string_extensions/string_extensions.dart';

class TextFiles extends StatefulWidget {
  const TextFiles({super.key});

  @override
  State<TextFiles> createState() => _TextFilesState();
}

class _TextFilesState extends State<TextFiles> {

  String? currentTextType=Localization.translate('text_choose_file_option');

  TextEditingController postController= TextEditingController();

  TextEditingController postTitleController= TextEditingController();

  @override
  void initState()
  {
    currentTextType=Localization.translate('text_choose_file_option');
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
                          currentTextType == Localization.translate('text_choose_file_option') ? Localization.translate('text_second_title') : Localization.translate('text_third_string_title'),
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
                                      currentTextType=Localization.translate('text_choose_file_option');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: Icon(
                                      Icons.file_present_outlined,
                                      color: currentTextType == Localization.translate('text_choose_file_option')
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
                                      currentTextType=Localization.translate('text_choose_string_option');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: Icon(
                                      Icons.text_snippet_outlined,
                                      color: currentTextType == Localization.translate('text_choose_string_option')
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

                        //If File => Build Upload File Widget, otherwise, enable a place for user to enter text
                        ConditionalBuilder(
                          condition: currentTextType == Localization.translate('text_choose_file_option'),

                          builder: (context)=>Expanded(
                            child: Center(
                              child: cubit.chosenTextFile ==null ? SizedBox(
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
                                    cubit.pickTextFile();
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
                                            cubit.chosenTextFile!.name.capitalize!,
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
                                          condition: cubit.chosenTextFile !=null,

                                          fallback: (context)=> const Icon(Icons.folder_open_rounded),

                                          builder: (context)=>GestureDetector(
                                            child: const Icon(Icons.remove, color: Colors.redAccent,),
                                            onTap: ()
                                            {
                                              cubit.removeTextFile();
                                            },
                                          ),
                                        ),
                                      ],


                                    ),
                                    onTap: ()
                                    async {
                                      openFile(cubit.chosenTextFile!.path!);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          fallback: (context)=>Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: defaultAddPostBox(
                                  context: context,
                                  cubit: cubit,
                                  boxColor: null,
                                  child: SizedBox(
                                    width: double.infinity,
                                    //height: MediaQuery.of(context).size.height /2.5,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:
                                      [
                                        const SizedBox(height: 5,),

                                        TextFormField(
                                          controller: postTitleController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            labelText: Localization.translate('text_add_string_post_name'),
                                            labelStyle: TextStyle(
                                              color: cubit.isDarkTheme? Colors.grey : Colors.black,
                                            ),
                                            floatingLabelBehavior: FloatingLabelBehavior.never,
                                          ),
                                          maxLines: 1,
                                        ),

                                        myDivider(),

                                        TextFormField(
                                          controller: postController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            labelText: Localization.translate('text_add_string_post_title'),
                                            labelStyle: TextStyle(
                                              color: cubit.isDarkTheme? Colors.grey : Colors.black,
                                            ),
                                            floatingLabelBehavior: FloatingLabelBehavior.never,
                                          ),
                                          maxLines: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){},
                                  paddingOptions: false,
                                ),
                                ),
                            ),
                            ),
                        ),

                        SizedBox(height: currentTextType == Localization.translate('text_choose_file_option') ? 10 : 25,),

                        Center(
                          child: ConditionalBuilder(
                            condition: state is! AppUploadTextInquiryLoadingState,

                            fallback: (context)=>defaultProgressIndicator(context),

                            builder:(context)=> defaultButton(
                              title: Localization.translate('upload_button'),
                              color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                              onTap: ()
                              async {
                                if(currentTextType == Localization.translate('text_choose_file_option'))
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
                                }

                                else
                                {
                                  if(postController.text.isNotEmpty && postTitleController.text.isNotEmpty)
                                  {
                                    //Create a File
                                    File file= await writeFileFromText(postController.text, postTitleController.text);

                                    //get it's platform File
                                    PlatformFile platformFile = PlatformFile(name: basename(file.path), size: await file.length(), path: file.path);


                                    cubit.uploadTextInquiry(

                                      file:platformFile,

                                      onSendProgress: (int sent, int total)
                                      {
                                        print('File is Being Uploaded: Sent:$sent Total:$total');
                                      },

                                    ).then((value) async
                                    {
                                      cubit.removeTextFile();
                                    }).catchError((error)
                                    {
                                      defaultToast(msg: error.toString());
                                    });
                                  }

                                  else
                                  {
                                    defaultToast(msg: Localization.translate('text_add_string_no_text'));
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
                            currentTextType == Localization.translate('text_choose_file_option') ? Localization.translate('text_second_title') : Localization.translate('text_third_string_title'),
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
                                          currentTextType=Localization.translate('text_choose_file_option');
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(22.0),
                                        child: Icon(
                                          Icons.file_present_outlined,
                                          color: currentTextType == Localization.translate('text_choose_file_option')
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
                                          currentTextType=Localization.translate('text_choose_string_option');
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(22.0),
                                        child: Icon(
                                          Icons.text_snippet_outlined,
                                          color: currentTextType == Localization.translate('text_choose_string_option')
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
                              condition: currentTextType == Localization.translate('text_choose_file_option'),

                              builder: (context)=>Center(
                                child: cubit.chosenTextFile ==null ? SizedBox(
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
                                      cubit.pickTextFile();
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
                                              cubit.chosenTextFile!.name.capitalize!,
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
                                            condition: cubit.chosenTextFile !=null,

                                            fallback: (context)=> const Icon(Icons.folder_open_rounded),

                                            builder: (context)=>GestureDetector(
                                              child: const Icon(Icons.remove, color: Colors.redAccent,),
                                              onTap: ()
                                              {
                                                cubit.removeTextFile();
                                              },
                                            ),
                                          ),
                                        ],


                                      ),
                                      onTap: ()
                                      async {
                                        openFile(cubit.chosenTextFile!.path!);
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              fallback: (context)=>Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: defaultAddPostBox(
                                    context: context,
                                    cubit: cubit,
                                    boxColor: null,
                                    child: SizedBox(
                                      width: double.infinity,
                                      //height: MediaQuery.of(context).size.height /2.5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children:
                                        [
                                          const SizedBox(height: 5,),

                                          TextFormField(
                                            controller: postTitleController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              labelText: Localization.translate('text_add_string_post_name'),
                                              labelStyle: TextStyle(
                                                color: cubit.isDarkTheme? Colors.grey : Colors.black,
                                              ),
                                              floatingLabelBehavior: FloatingLabelBehavior.never,
                                            ),
                                            maxLines: 1,
                                          ),

                                          myDivider(),

                                          TextFormField(
                                            controller: postController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              labelText: Localization.translate('text_add_string_post_title'),
                                              labelStyle: TextStyle(
                                                color: cubit.isDarkTheme? Colors.grey : Colors.black,
                                              ),
                                              floatingLabelBehavior: FloatingLabelBehavior.never,
                                            ),
                                            maxLines: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: (){},
                                    paddingOptions: false,
                                  ),
                                ),
                              ),
                            ),

                            // Center(
                            //   child: cubit.chosenFile ==null ? SizedBox(
                            //     height: MediaQuery.of(context).size.height /5,
                            //     width: MediaQuery.of(context).size.width /2,
                            //     child: defaultBox(
                            //       cubit: cubit,
                            //       boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                            //       borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor.withOpacity(0.9) : defaultSecondaryColor.withOpacity(0.9),
                            //       manualBorderColor: true,
                            //       child: const Center(
                            //           child: Icon(
                            //             Icons.add,
                            //             size: 35,
                            //           )
                            //       ),
                            //       onTap: ()
                            //       {
                            //         cubit.pickFile();
                            //       },
                            //     ),
                            //   ) :
                            //   Padding(
                            //     padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
                            //     child: SizedBox(
                            //       child: defaultBox(
                            //         padding: 28,
                            //         cubit: cubit,
                            //         boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           crossAxisAlignment: CrossAxisAlignment.center,
                            //
                            //           children:
                            //           [
                            //             Expanded(
                            //               child: Text(
                            //                 cubit.chosenFile!.name.capitalize!,
                            //                 style: TextStyle(
                            //                   fontWeight: FontWeight.w500,
                            //                   color: cubit.isDarkTheme? defaultSecondaryDarkColor : Colors.white,
                            //                   fontSize: 16,
                            //                 ),
                            //                 maxLines: 1,
                            //                 overflow: TextOverflow.ellipsis,
                            //               ),
                            //             ),
                            //
                            //             const SizedBox(width: 5,),
                            //
                            //             ConditionalBuilder(
                            //               condition: cubit.chosenFile !=null,
                            //
                            //               fallback: (context)=> const Icon(Icons.folder_open_rounded),
                            //
                            //               builder: (context)=>GestureDetector(
                            //                 child: const Icon(Icons.remove, color: Colors.redAccent,),
                            //                 onTap: ()
                            //                 {
                            //                   cubit.removeFile();
                            //                 },
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         onTap: ()
                            //         async {
                            //           openFile(cubit.chosenFile!.path!);
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            // ),

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
