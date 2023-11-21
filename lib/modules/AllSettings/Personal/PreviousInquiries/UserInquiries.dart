import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/InquiryModel/InquiryModel.dart';
import 'package:deepfake_detection/modules/InquiryDetails/InquiryDetails.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInquiries extends StatelessWidget {
  const UserInquiries({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {
        if(state is AppDeleteInquiryLoadingState)
          {
            defaultToast(msg: Localization.translate('delete_inquiry_loading_toast'));
          }

        if(state is AppDeleteInquiryErrorState)
          {
            defaultToast(msg: '${Localization.translate('delete_inquiry_error_toast')}, ${state.error}', state: ToastStates.error);
          }

        if(state is AppDeleteAPostSuccessState)
          {
            defaultToast(msg: Localization.translate('delete_inquiry_successfully_toast'));
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
                Localization.translate('previous_inquiries_title'),
                style:TextStyle(
                    color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                    fontFamily: 'WithoutSans',
                    fontWeight: FontWeight.w600
                ),
              ),
            ),

            body: RefreshIndicator(

              onRefresh: ()async
              {
                return await Future(()=> cubit.getInquiries());
              },

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children:
                    [
                      ConditionalBuilder(
                        condition: cubit.inquiryModel !=null,
                        builder: (context)=>ListView.separated(
                          itemBuilder: (context,index)=>itemBuilder(inquiry: cubit.inquiryModel!.inquiries![index], cubit: cubit, context: context),
                          separatorBuilder: (context,index)=> Column(
                            children:
                            [
                              const SizedBox(height: 20,),
                              myDivider(color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor),
                              const SizedBox(height: 20,),
                            ],
                          ),
                          itemCount: cubit.inquiryModel!.inquiries!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                        fallback: (context)=> Center(child: defaultProgressIndicator(context)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget itemBuilder({required BuildContext context, required Inquiry inquiry , required AppCubit cubit})=> InkWell(
    highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
    onTap: ()
    {
      navigateTo(context, InquiryDetails(inquiry: inquiry));
    },
    child: Column(
      children:
      [
        Text(
          inquiry.name!,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 10,),

        Text(
          dateFormatter(inquiry.createdAt!),
          style: TextStyle(
            color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
          ),
        ),

        const SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              inquiry.result!.toUpperCase() =='REAL' ? Localization.translate('correct_your_inquiries') : Localization.translate('fake_your_inquiries') ,
              style: TextStyle(
                color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
            ),

            const Spacer(),
            
            IconButton(
              onPressed: ()
              {
                showDialog(
                    context: context,
                    builder: (dialogContext)
                    {
                      return defaultAlertDialog(
                          context: dialogContext,
                          title: Localization.translate('delete_title_previous_inquiries'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children:
                              [
                                Text(Localization.translate('delete_secondary_title_previous_inquiries')),

                                const SizedBox(height: 5,),

                                Row(
                                  children:
                                  [
                                    TextButton(
                                        onPressed: ()
                                        {
                                          cubit.deleteInquiry(inquiry.id!);
                                          Navigator.pop(dialogContext);
                                        },
                                        child: Text(Localization.translate('yes_your_inquiries'))
                                    ),

                                    const Spacer(),

                                    TextButton(
                                      onPressed: ()
                                      {
                                        Navigator.pop(dialogContext);
                                      },
                                      child: Text(Localization.translate('no_your_inquiries')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    }
                );
              },
              icon: const Icon(Icons.remove, color: Colors.redAccent,size: 28),

            ),
          ],
        ),
      ],
    ),
  );
}
