import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/InquiryModel/InquiryModel.dart';
import 'package:deepfake_detection/modules/InquiryDetails/InquiryDetails.dart';
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
            defaultToast(msg: 'Deleting Inquiry...');
          }

        if(state is AppDeleteInquiryErrorState)
          {
            defaultToast(msg: 'Error on Deleting Inquiry, ${state.error}', state: ToastStates.error);
          }

        if(state is AppDeleteAPostSuccessState)
          {
            defaultToast(msg: 'Deleted Successfully');
          }
      },
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Previous Inquiries',
              style:TextStyle(
                  color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                  fontFamily: 'WithoutSans',
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          body: SingleChildScrollView(
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
              inquiry.result!.toUpperCase(),
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
                          title: 'DELETE INQUIRY',
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children:
                              [
                                const Text('Do you want to delete this inquiry ?',),

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
                                        child: const Text('YES')
                                    ),

                                    const Spacer(),

                                    TextButton(
                                      onPressed: ()
                                      {
                                        Navigator.pop(dialogContext);
                                      },
                                      child: const Text('NO'),
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
