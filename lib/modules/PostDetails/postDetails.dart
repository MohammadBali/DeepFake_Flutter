import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/PostModel/PostModel.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetails extends StatelessWidget {
  Post post;
  PostDetails({super.key, required this.post});

  TextEditingController addCommentController=TextEditingController();


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
                padding: const EdgeInsetsDirectional.only(start: 28.0, end:28.0, top:28.0, bottom: 10.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children:
                    [
                      postItemBuilder(
                        cubit: cubit,
                        context: context,
                        post: post,
                        isCommentClickable: false,
                        isBoxClickable: false,
                      ),

                      const SizedBox(height: 20,),


                      defaultBox(
                        cubit: cubit,
                        boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                        onTap: (){},
                        child: Column(
                          children: [

                            addCommentItemBuilder(cubit: cubit, context: context),

                            Visibility(
                              visible: post.comments!.isNotEmpty,
                              child: Container(width: double.infinity, height: 1, color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor,)
                            ),

                            Visibility(
                              visible: post.comments!.isNotEmpty,
                              child: const SizedBox(height: 20),
                            ),

                            ConditionalBuilder(
                              condition: post.comments!.isNotEmpty,
                              builder: (context)=> ListView.separated(
                                itemBuilder: (context,index)=>commentItemBuilder(cubit: cubit, comment: post.comments![index], context: context),
                                separatorBuilder: (context,index)=> Column(
                                  children:
                                  [
                                    const SizedBox(height: 20),

                                    Container(width: double.infinity, height: 1, color: cubit.isDarkTheme? defaultDarkColor : defaultColor,),

                                    const SizedBox(height: 20),
                                  ],
                                ),

                                itemCount: post.comments!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                              ),

                              fallback: (context) => const SizedBox(height: 1,),
                            ),

                          ],
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


  Widget addCommentItemBuilder({required AppCubit cubit, required BuildContext context})=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children:
    [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Column(
                children:
                [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/${AppCubit.userData!.photo!}'),
                    radius: 22,
                  ),

                  const SizedBox(height: 8,),

                  Text(
                    AppCubit.userData!.name!.length >10 ? '${AppCubit.userData!.name!.substring(0,10)}...' : AppCubit.userData!.name!  ,
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
                  child:  TextFormField(
                    controller: addCommentController,
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
                    maxLines: 2,
                  ),
                ),
              ),


            ],
          ),

          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: TextButton(
              child: const Text(
                'ADD COMMENT',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: ()
              {
                if(addCommentController.text.isNotEmpty)
                  {
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
    ],
  );
}
