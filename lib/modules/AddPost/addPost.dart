import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/InquiryModel/InquiryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class AddPost extends StatelessWidget {
  AddPost({super.key, required this.inquiry});

  final Inquiry inquiry;

  TextEditingController postController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {
          if(state is AppUploadPostLoadingState)
            {
              defaultToast(msg: 'Uploading...');
            }

          if(state is AppUploadPostErrorState)
            {
              defaultToast(msg: 'Error, ${state.error}', state: ToastStates.error);
            }

          if(state is AppUploadPostSuccessState)
            {
              defaultToast(msg: 'Uploaded Successfully');
              Navigator.pop(context);
            }
        },
        builder: (context,state)
        {
          var cubit=AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Add Post',
                style: TextStyle(
                    color: cubit.isDarkTheme? defaultDarkFontColor: defaultFontColor,
                    fontFamily: 'WithoutSans',
                    fontWeight: FontWeight.w600
                ),
              ),
            ),

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Text(
                      'Upload a New Post and Share Your Results',
                      style: TextStyle(
                        color:cubit.isDarkTheme? defaultDarkColor : defaultColor ,
                        fontWeight: FontWeight.w500,
                        fontSize: 26,
                        fontFamily: 'Neology',
                      ),
                    ),

                    const SizedBox(height: 40,),

                    defaultAddPostBox(
                      context: context,
                      cubit: cubit,
                      boxColor: null,
                      child: SizedBox(
                        width: double.infinity,
                        //height: MediaQuery.of(context).size.height /2.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                          [
                            TextFormField(
                              controller: postController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Add a Comment',
                                labelStyle: TextStyle(
                                  color: cubit.isDarkTheme? Colors.grey : Colors.black,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                              ),
                              maxLines: null,
                            ),


                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
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
                                          inquiry.name!.capitalize!,
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

                                      const Icon(Icons.file_copy_outlined),
                                    ],
                                  ),
                                  onTap: (){},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: (){},
                      paddingOptions: false,
                    ),

                    const SizedBox(height: 25,),

                    Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: TextButton(
                        child: const Text(
                          'ADD POST',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed: ()
                        {
                          if(postController.text.isNotEmpty)
                          {
                            cubit.uploadPost(
                              inquiryId: inquiry.id!,
                              comment: postController.text,
                              ownerId: AppCubit.userData!.id!,
                            );
                          }
                          else
                          {
                            defaultToast(msg: 'No Data to post');
                          }
                        },
                      ),
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
