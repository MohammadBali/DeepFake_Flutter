import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/PostModel/PostModel.dart';
import 'package:deepfake_detection/modules/PostDetails/postDetails.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {
        if(state is AppDeleteAPostLoadingState)
          {
            defaultToast(msg: 'Deleting Post...');
          }

        if(state is AppDeleteAPostErrorState)
          {
            defaultToast(msg: 'Error While Deleting, ${state.error}', state: ToastStates.error);
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
              Localization.translate('appBar_title_your_posts'),
              style:TextStyle(
                  color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                  fontFamily: 'WithoutSans',
                  fontWeight: FontWeight.w600
              ),
            ),
          ),

          body: Directionality(
            textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children:
                  [
                    ConditionalBuilder(
                      condition: cubit.userPostsModel !=null,
                      builder: (context)=>ListView.separated(
                          itemBuilder: (context,index)=>itemBuilder(post: cubit.userPostsModel!.posts![index], cubit: cubit, context: context),
                          separatorBuilder: (context,index)=> Column(
                            children:
                            [
                              const SizedBox(height: 20,),
                              myDivider(color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor),
                              const SizedBox(height: 20,),
                            ],
                          ),
                          itemCount: cubit.userPostsModel!.posts!.length,
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
        );
      },
    );
  }

  Widget itemBuilder({required BuildContext context, required Post post , required AppCubit cubit})=> InkWell(
    highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
    onTap: ()
    {
      navigateTo(context, PostDetails(post: post));
    },
    child: Column(
      children:
      [
        Text(
          post.title!,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 10,),

        Text(
          dateFormatter(post.createdAt!),
          style: TextStyle(
            color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
          ),
        ),

        const SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                      title: Localization.translate('delete_title_your_posts'),
                        content: SingleChildScrollView(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children:
                        [
                          Text(Localization.translate('delete_secondary_title_your_posts'),),

                          const SizedBox(height: 5,),

                          Row(
                            children:
                            [
                              TextButton(
                                onPressed: ()
                                {
                                  cubit.deletePost(post.id!);
                                  Navigator.pop(dialogContext);
                                },
                                child: Text(Localization.translate('yes_your_posts'))
                              ),

                              const Spacer(),

                              TextButton(
                                  onPressed: ()
                                  {
                                    Navigator.pop(dialogContext);
                                  },
                                  child:  Text(Localization.translate('no_your_posts')),
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
