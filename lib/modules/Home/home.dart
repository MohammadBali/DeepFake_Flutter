import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/NewsModel/NewsModel.dart';
import 'package:deepfake_detection/modules/NewsPage/newsPage.dart';
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

  @override
  void initState()
  {
    super.initState();

    AppCubit cubit= AppCubit.get(context);

    scrollController.addListener(()
    {
      _onScroll(cubit);
    });
  }

  @override
  void dispose()
  {
    // scrollController.removeListener(()
    // {
    //   _onScroll();
    // });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        return SingleChildScrollView(
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
                      ),
                    ),
                    fallback: (context)=> progressQuoteBuilder(cubit, context),
                  ),

                  const SizedBox(height: 40,),

                  ConditionalBuilder(
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

                  const SizedBox(height: 20,),

                  //If Loading New Posts => Show Loading Progress Bar
                  if(state is AppGetNewPostsLoadingState)
                  defaultLinearProgressIndicator(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _onScroll(AppCubit cubit)
  {

    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) //scrollController.position.maxScrollExtent * threshold
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
              'AI News',
              style: TextStyle(
                fontSize: 26,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontFamily: 'WithoutSans',
                color: cubit.isDarkTheme? defaultDarkFontColor : Colors.white,
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

  Widget progressQuoteBuilder(AppCubit cubit, BuildContext context)=>defaultBox(
      cubit: cubit,
      boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
      child: Center(child: defaultLinearProgressIndicator(context),),
      paddingOptions:false,
      onTap: (){},
  );
}
