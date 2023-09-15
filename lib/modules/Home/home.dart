import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/PostDetails/postDetails.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:deepfake_detection/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                [

                  quoteItemBuilder(cubit: cubit, quote: 'Smile and Bring Joy to The World !'),

                  const SizedBox(height: 40,),

                  ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (context,index)=>const SizedBox(height: 25,),
                    itemBuilder: (context,index)=>postItemBuilder(cubit: cubit, name: 'Rachel', context: context),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget quoteItemBuilder({required AppCubit cubit, required String quote})=>defaultBox(
    cubit: cubit,
    boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        Align(
          alignment:AlignmentDirectional.bottomStart,
          child: Text(
            'Quote of The Day',
            style: TextStyle(
              fontSize: 26,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              fontFamily: 'WithoutSans',
              color: cubit.isDarkTheme? defaultDarkFontColor : Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 20,),

        Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Text(
            quote,
            style: TextStyle(
              fontSize: 16,
              color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultFontColor,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    onTap: ()
    {},
  );


}
