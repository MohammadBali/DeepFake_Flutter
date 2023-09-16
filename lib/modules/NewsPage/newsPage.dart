import 'package:cached_network_image/cached_network_image.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/NewsModel/NewsModel.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatelessWidget {

  Article article;

  NewsPage({super.key, required  this.article});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Text(
                    article.title!,
                    style: TextStyle(
                      color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                      fontSize: 28,
                      fontFamily: 'Neology',
                    ),
                  ),

                  const SizedBox(height: 25,),

                  GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: article.image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (context,url)=> Center(child: defaultLinearProgressIndicator(context)),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error, size: 30,)),
                  ),

                  onTap: ()
                  async {
                    await defaultLaunchUrl(article.url!);
                  },
                ),

                  Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Text(
                    article.date!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                  const SizedBox(height: 25,),

                  Text(
                    article.description!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        wordSpacing: 2,
                        fontStyle: FontStyle.italic,
                    ),

                  ),

                  const SizedBox(height: 25,),

                  myDivider(),

                  const SizedBox(height: 25,),

                  Text(
                    article.content!,
                    style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    wordSpacing: 2,
                  ),
                  ),





                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
