import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/InquiryDetails/InquiryDetails.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFiles extends StatelessWidget {
  const TextFiles({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Text(
                'Upload Text File',
                style: TextStyle(
                  color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                  fontSize: 32,
                  fontFamily: 'Neology',
                ),
              ),

              const SizedBox(height: 25,),


              const Text(
                'Choose a File to Upload',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  wordSpacing: 2
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

              ),

             const Spacer(),


              Center(
                child: SizedBox(
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
                    onTap: (){},
                  ),
                ),
              ),


              const Spacer(),

              Expanded(
                child: Center(
                  child: defaultButton(
                    color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                    onTap: ()
                    {
                      navigateTo(context, InquiryDetails(
                        inquiry: cubit.inquiryModel!.inquiries![0], //TO BE CHANGED
                      )
                      );
                    },
                    textColor: cubit.isDarkTheme? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
