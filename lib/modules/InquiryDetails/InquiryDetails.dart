import 'dart:io';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/InquiryModel/InquiryModel.dart';
import 'package:deepfake_detection/modules/AddPost/addPost.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_extensions/string_extensions.dart';

class InquiryDetails extends StatelessWidget {
  const InquiryDetails({super.key, required this.inquiry});

  final Inquiry inquiry;
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
                  Localization.translate('appBar_title_inquiry_details'),
                  style: TextStyle(
                    color: cubit.isDarkTheme? defaultDarkFontColor: defaultFontColor,
                    fontFamily: 'WithoutSans',
                    fontWeight: FontWeight.w600
                  ),
                ),
                actions:
                [
                  IconButton(
                    onPressed: ()
                    {
                      navigateTo(context, AddPost(inquiry: inquiry,));
                    },
                    icon: const Icon(Icons.share_rounded)
                  ),
                ],
              ),

              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      const SizedBox(height: 20,),

                      Padding(
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

                              const Icon(Icons.folder_open_rounded),
                            ],
                          ),
                          onTap: ()
                          async {
                            File? file=await base64ToFile(inquiry.data!, inquiry.type!);

                            if(file!=null)
                              {
                                print('Converted File');
                                openFile(file.path);
                              }
                          },
                        ),
                      ),

                      const SizedBox(height: 40,),

                      Text(
                        inquiry.result?.toUpperCase() =='CORRECT' ? Localization.translate('correct_secondary_inquiry_details') : Localization.translate('fake_secondary_inquiry_details'),
                        style: TextStyle(
                          color: cubit.isDarkTheme? defaultDarkFontColor: defaultFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Image(
                        image: AssetImage('assets/images/geoface1.png'),
                        alignment: AlignmentDirectional.center,
                        height: 400,
                      ),

                      const SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),

                          Text(
                            inquiry.result?.toUpperCase() =='CORRECT' ? Localization.translate('correct_result_inquiry_details') : Localization.translate('fake_result_inquiry_details') ,
                            style: TextStyle(
                              color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                              fontSize: 30,
                              fontFamily: 'Neology',
                              letterSpacing: 2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          const Spacer(),

                          Icon(
                            inquiry.result =='correct' ? Icons.check_rounded : Icons.cancel_outlined,
                            size: 32,
                            color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                          )
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
