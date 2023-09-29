import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/InquiryModel/InquiryModel.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
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
              defaultToast(msg: Localization.translate('upload_post_loading_toast'));
            }

          if(state is AppUploadPostErrorState)
            {
              defaultToast(msg: '${Localization.translate('upload_post_error_toast')}, ${state.error}', state: ToastStates.error);
            }

          if(state is AppUploadPostSuccessState)
            {
              defaultToast(msg: Localization.translate('upload_post_successfully_toast'));
              Navigator.pop(context);
            }
        },
        builder: (context,state)
        {
          var cubit=AppCubit.get(context);
          return Directionality(
            textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  Localization.translate('appBar_title_add_post'),
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
                        Localization.translate('title_add_post'),
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
                                  labelText: Localization.translate('add_comment_add_post'),
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
                          child: Text(
                            Localization.translate('add_post_add_post'),
                            style: const TextStyle(
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
                              defaultToast(msg: Localization.translate('upload_post_no_data_toast'));
                            }
                          },
                        ),
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
