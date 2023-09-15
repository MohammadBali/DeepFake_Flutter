import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFileResult extends StatelessWidget {
  const TextFileResult({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit=AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Text Result',
                style: TextStyle(
                  color: cubit.isDarkTheme? defaultDarkFontColor: defaultFontColor,
                  fontFamily: 'WithoutSans',
                  fontWeight: FontWeight.w600
                ),
              ),
            ),

            body: Padding(
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
                              'Dr.Nowatski Paper.docx',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: cubit.isDarkTheme? defaultSecondaryDarkColor : Colors.white,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(width: 5,),

                          Icon(Icons.file_copy_outlined),
                        ],
                      ),
                      onTap: (){},
                    ),
                  ),

                  const SizedBox(height: 40,),

                  Expanded(
                    child: Text(
                      'This Text file is not fake and it is valid.',
                      style: TextStyle(
                        color: cubit.isDarkTheme? defaultDarkFontColor: defaultFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      Text(
                        'Valid Data',
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
                        Icons.check_rounded,
                        size: 32,
                        color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                      )
                    ],
                  ),

                ],
              ),
            ),
          );
        },

    );
  }
}
