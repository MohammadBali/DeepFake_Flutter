import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/components/Localization/Localization.dart';
import '../../../../shared/styles/colors.dart';

class LearnMore extends StatelessWidget {
  const LearnMore({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit= AppCubit.get(context);

          return Directionality(
            textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  Localization.translate('learn_more_profile'),
                  style:TextStyle(
                      color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                      fontFamily: 'WithoutSans',
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),

              body: OrientationBuilder(
                builder: (context,orientation)
                {
                  if(orientation == Orientation.portrait)
                    {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            Center(
                              child: Text(
                                Localization.translate('learn_more_page_title'),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Neology',
                                  color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                ),

                              ),
                            ),

                            const SizedBox(height: 45,),

                            myDivider(),

                            const SizedBox(height: 45,),

                            Text(
                              Localization.translate('learn_more_page_ai_dev'),
                              style: const TextStyle(
                                fontSize: 22,
                              ),
                            ),

                            const SizedBox(height: 25,),

                            Text(
                              Localization.translate('farah_haltey'),
                              style: TextStyle(
                                fontSize: 18,
                                color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                wordSpacing: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20,),

                            Text(
                              Localization.translate('mina_ibrahim'),
                              style: TextStyle(
                                fontSize: 18,
                                color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                wordSpacing: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20,),

                            Text(
                              Localization.translate('raneem_zerkley'),
                              style: TextStyle(
                                fontSize: 18,
                                color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                wordSpacing: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 45,),

                            myDivider(),

                            const SizedBox(height: 45,),

                            Text(
                              Localization.translate('learn_more_page_software_dev'),
                              style: const TextStyle(
                                fontSize: 22,
                              ),
                            ),

                            const SizedBox(height: 25,),

                            Text(
                              Localization.translate('mohammad_bali'),
                              style: TextStyle(
                                fontSize: 18,
                                color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                wordSpacing: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 45,),

                            Align(
                              alignment: AlignmentDirectional.center,
                              child: Image(
                                image: AssetImage(cubit.isDarkTheme? 'assets/images/splash/dark_logo.png' : 'assets/images/splash/light_logo.png'),
                                fit: BoxFit.contain,
                                height: 150,
                                width: 150,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  else
                    {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                            [
                              Center(
                                child: Text(
                                  Localization.translate('learn_more_page_title'),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'Neology',
                                    color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                  ),

                                ),
                              ),

                              const SizedBox(height: 45,),

                              myDivider(),

                              const SizedBox(height: 45,),

                              Text(
                                Localization.translate('learn_more_page_ai_dev'),
                                style: const TextStyle(
                                  fontSize: 22,
                                ),
                              ),

                              const SizedBox(height: 25,),

                              Text(
                                Localization.translate('farah_haltey'),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                  wordSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20,),

                              Text(
                                Localization.translate('mina_ibrahim'),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                  wordSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20,),

                              Text(
                                Localization.translate('raneem_zerkley'),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                  wordSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 45,),

                              myDivider(),

                              const SizedBox(height: 45,),

                              Text(
                                Localization.translate('learn_more_page_software_dev'),
                                style: const TextStyle(
                                  fontSize: 22,
                                ),
                              ),

                              const SizedBox(height: 25,),

                              Text(
                                Localization.translate('mohammad_bali'),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                                  wordSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 45,),

                              Center(
                                child: Image(
                                  image: AssetImage(cubit.isDarkTheme? 'assets/images/splash/dark_logo.png' : 'assets/images/splash/light_logo.png'),
                                  fit: BoxFit.contain,
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                },
              ),
            ),
          );
        },
    );
  }
}
