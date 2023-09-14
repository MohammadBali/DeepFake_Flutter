import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:deepfake_detection/shared/styles/styles.dart';
import 'package:flutter/material.dart';
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
                    itemBuilder: (context,index)=>postItemBuilder(cubit: cubit, name: 'Rachel'),
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
  );


  Widget postItemBuilder({required AppCubit cubit, required String name})=>defaultBox(
      boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children:
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Column(
                children:
                [
                  const CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 22,
                  ),

                  const SizedBox(height: 8,),

                  Text(
                    name.length >6 ? '${name.substring(0,6)}...' : name  ,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                ],
              ),

              const SizedBox(width: 10,),

              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 8.0, start: 8.0),
                  child: Text(
                    'No Way This Document is Fake!',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),


            ],
          ),

          const SizedBox(height: 15,),

          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Wrap(
                  alignment:WrapAlignment.spaceBetween,
                  runAlignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.vertical,
                  children:
                  [
                    IconButton(
                        onPressed: ()
                        {

                        },
                        icon: Icon(
                          Icons.thumb_up_off_alt_outlined,
                          color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                        )
                    ),

                    Text(
                      '15',
                    ),
                  ],
                ),

                Wrap(
                  alignment:WrapAlignment.spaceBetween,
                  runAlignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.vertical,
                  children:
                  [
                    IconButton(
                        onPressed: ()
                        {

                        },
                        icon: Icon(
                          Icons.comment_rounded,
                          color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                        )
                    ),

                    Text(
                      '250',
                    ),
                  ],
                ),

                const Spacer(),

                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: defaultQueryBox(
                    boxColor: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor,
                    child: Text(
                      'Chat with Allen.docx',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
  );
}
