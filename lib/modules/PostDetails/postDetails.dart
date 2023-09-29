import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/PostModel/PostModel.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetails extends StatelessWidget {
  Post globalPost;
  PostDetails({super.key, required this.globalPost});

  TextEditingController addCommentController=TextEditingController();

  int postIndex=0;

  bool isDeleted=false;

  @override
  Widget build(BuildContext context) {

    Post post=globalPost;
    try
    {
      print(AppCubit.postModel!.posts!.indexOf(globalPost));
      postIndex= AppCubit.postModel!.posts!.indexOf(globalPost);
      post= AppCubit.postModel!.posts![postIndex];
    }
    catch (e,stackTrace)
    {
      print('ERROR IN POST DETAILS PAGE, ${e.toString()} $stackTrace');
    }

    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {
          if(state is AppWSAddLikePostModelSuccessState)
            {
                post=state.post;
            }

          if(state is AppWSModifyCommentPostModelSuccessState)
            {
              post=state.post;
            }

          if(state is AppWSDeletePostPostModelSuccessState)
            {
              if(post.id! == state.post.id!)
                {
                  isDeleted=true;
                }
            }
        },
        builder: (context,state)
        {
          var cubit =AppCubit.get(context);

          return Directionality(
            textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  Localization.translate('post_details_title'),
                  style:TextStyle(
                    color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                    fontFamily: 'WithoutSans',
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),

              body: ConditionalBuilder(
                condition: isDeleted==false && post !=null,
                builder: (context)=>SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 28.0, end:28.0, top:28.0, bottom: 10.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                        [
                          Builder(builder: (context)=>postItemBuilder(
                            cubit: cubit,
                            context: context,
                            post: post,
                            isCommentClickable: false,
                            isBoxClickable: false,
                          ),
                          ),
                          const SizedBox(height: 20,),


                          defaultBox(
                            cubit: cubit,
                            boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                            onTap: (){},
                            child: Column(
                              children: [

                                addCommentItemBuilder(cubit: cubit, context: context, post: post),

                                Visibility(
                                    visible: post.comments!.isNotEmpty,
                                    child: Container(width: double.infinity, height: 1, color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor,)
                                ),

                                Visibility(
                                  visible: post.comments!.isNotEmpty,
                                  child: const SizedBox(height: 20),
                                ),

                                Builder(
                                  builder: (context)=>ConditionalBuilder(
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
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                fallback: (context)=> Center(
                child: Text(
                  Localization.translate('post_is_deleted'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                ),
                ),
                ),
              ),


            ),
          );
        },
    );
  }


  Widget addCommentItemBuilder({required AppCubit cubit, required BuildContext context, required Post post})=>Column(
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
                    backgroundImage: AssetImage('assets/images/profile/${AppCubit.userData!.photo!}'),
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
                      labelText: Localization.translate('add_comment_post_details'),
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
              child: Text(
                Localization.translate('add_comment_post_details').toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: ()
              {
                if(addCommentController.text.isNotEmpty)
                  {
                    cubit.addComment(
                      userID: AppCubit.userData!.id!,
                      postID: post.id!,
                      comment: addCommentController.text,
                    );

                    addCommentController.text='';
                  }
                else
                  {
                    defaultToast(msg: Localization.translate('comment_no_data_toast'));
                  }
              },
            ),
          ),
        ],
      ),
    ],
  );
}
