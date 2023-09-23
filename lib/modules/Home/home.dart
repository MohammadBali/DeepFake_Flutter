import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/NewsModel/NewsModel.dart';
import 'package:deepfake_detection/models/PostModel/PostModel.dart';
import 'package:deepfake_detection/modules/NewsPage/newsPage.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ScrollController scrollController= ScrollController();
  final GlobalKey _key = GlobalKey();

  String? currentFeed=Localization.translate('feed_home');

  @override
  void initState()
  {
    super.initState();

    AppCubit cubit= AppCubit.get(context);

    currentFeed=Localization.translate('feed_home');

    scrollController.addListener(()
    {
      _onScroll(cubit);
    });

  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);

        return RefreshIndicator(
          onRefresh:() async
          {
            await cubit.checkForNewPosts();
          },
          child: SingleChildScrollView(
            controller: scrollController,
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  [

                    ConditionalBuilder(
                      condition: cubit.newsModel !=null,
                      builder: (context) =>SizedBox(
                        height: 150,
                        child: ListView.separated(
                          itemBuilder: (context,index)=> newsItemBuilder(cubit: cubit, article: cubit.newsModel!.articles![index], context: context),
                          separatorBuilder: (context,index)=> const SizedBox(width: 20,),
                          itemCount: cubit.newsModel!.articles!.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          //reverse: AppCubit.language == 'en' ? false : true,
                        ),
                      ),
                      fallback: (context)=> progressNewsBuilder(cubit, context),
                    ),

                    const SizedBox(height: 40,),

                    Align(
                      alignment: AlignmentDirectional.center,
                      child: defaultBox(
                        cubit: cubit,
                        boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                        borderColor: cubit.isDarkTheme? defaultDarkColor: defaultColor,
                        manualBorderColor: true,
                        paddingOptions: false,
                        padding: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                          [
                            GestureDetector(
                              onTap: ()
                              {
                                setState(() {
                                  currentFeed=Localization.translate('feed_home');
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(22.0),
                                child: Text(
                                  Localization.translate('feed_home'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: currentFeed == Localization.translate('feed_home')
                                        ? cubit.isDarkTheme? defaultDarkColor : defaultColor
                                        : cubit.isDarkTheme? Colors.white : defaultHomeColor

                                  ),
                                ),
                              ),
                            ),

                            RotatedBox(
                              quarterTurns: 1,
                              child: Container(
                                height: 2,
                                width: 30,
                                color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                              ),
                            ),

                            GestureDetector(
                              onTap: ()
                              {
                                setState(() {
                                  currentFeed=Localization.translate('my_feed_home');
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(22.0),
                                child: Text(
                                  Localization.translate('my_feed_home'),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: currentFeed == Localization.translate('my_feed_home')
                                          ? cubit.isDarkTheme? defaultDarkColor : defaultColor
                                          : cubit.isDarkTheme? Colors.white : defaultHomeColor
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),

                    const SizedBox(height: 40,),

                    ConditionalBuilder(
                      condition: currentFeed == Localization.translate('feed_home'),

                      builder: (context)=>ConditionalBuilder(
                        condition: AppCubit.postModel!=null,
                        builder: (context)=>ListView.separated(
                          itemCount: AppCubit.postModel!.posts!.length,
                          separatorBuilder: (context,index)=>const SizedBox(height: 25,),
                          itemBuilder: (context,index)=>postItemBuilder(cubit: cubit, post: AppCubit.postModel!.posts![index], context: context),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                        fallback: (context)=> Center(child: defaultProgressIndicator(context)),
                      ),

                      fallback: (context)=> ConditionalBuilder(
                        condition: cubit.subscriptionsPostsModel !=null,
                        builder: (context)=>ListView.separated(
                          itemCount: cubit.subscriptionsPostsModel!.posts!.length,
                          separatorBuilder: (context,index)=>const SizedBox(height: 25,),
                          itemBuilder: (context,index)=>postItemBuilder(cubit: cubit, post: cubit.subscriptionsPostsModel!.posts![index], context: context),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                        fallback: (context)=> Center(child: defaultProgressIndicator(context),),
                      ),
                    ),

                    const SizedBox(height: 20,),

                    //If Loading New Posts => Show Loading Progress Bar
                    if(state is AppGetNewPostsLoadingState)
                    defaultLinearProgressIndicator(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  void _onScroll(AppCubit cubit)
  {
    //Will Scroll Only and Only if: 1. Got to the end of the list / 2. is in the Feed home NOT MY FEED
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && currentFeed == Localization.translate('feed_home'))
    {
      if(AppCubit.postModel?.pagination?.nextPage !=null)
        {
          cubit.getNextPosts(nextPage: AppCubit.postModel?.pagination?.nextPage);  //Get Data from Cubit.
        }

    }



  }

  Widget newsItemBuilder({required AppCubit cubit, required Article article, required BuildContext context})=>defaultBox(
    cubit: cubit,
    boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
    child: Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Align(
            alignment:AlignmentDirectional.bottomStart,
            child: Text(
              Localization.translate('news_title'),
              style: TextStyle(
                fontSize: 26,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontFamily: 'WithoutSans',
                color: cubit.isDarkTheme? defaultDarkFontColor : defaultHomeColor,
              ),
            ),
          ),

          const Spacer(),

          Center(
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: SizedBox(
                width: MediaQuery.of(context).size.width/1.5,
                child: Text(
                  article.title!,
                  style: TextStyle(
                    fontSize: 16,
                    color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultFontColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    onTap: ()
    {
      navigateTo(context, NewsPage(article: article));
    },
  );

  Widget progressNewsBuilder(AppCubit cubit, BuildContext context)=>defaultBox(
      cubit: cubit,
      boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
      child: Center(child: defaultLinearProgressIndicator(context),),
      paddingOptions:false,
      onTap: (){},
  );
}
