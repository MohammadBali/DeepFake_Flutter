import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit =AppCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Post Details',
                style:TextStyle(
                  color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                  fontFamily: 'WithoutSans',
                  fontWeight: FontWeight.w600
                ),
              ),
            ),

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children:
                    [
                      postItemBuilder(
                        cubit: cubit,
                        name: 'Rachel',
                        context: context
                      ),

                      const SizedBox(height: 20,),


                      defaultBox(
                        cubit: cubit,
                        boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                        onTap: (){},
                        child: ListView.separated(
                          itemBuilder: (context,index)=>commentItemBuilder(cubit: cubit, name: 'name', context: context),
                          separatorBuilder: (context,index)
                          {
                            return Column(
                              children:
                              [
                                const SizedBox(height: 20),

                                Container(width: double.infinity, height: 1, color: cubit.isDarkTheme? defaultDarkColor : defaultColor,),

                                const SizedBox(height: 20),
                              ],
                            );
                          },
                          itemCount: 5,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
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
