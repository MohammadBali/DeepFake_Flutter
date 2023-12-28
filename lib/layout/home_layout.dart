import 'dart:async';
import 'dart:io';

import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeLayout extends StatelessWidget with WidgetsBindingObserver {

  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit= AppCubit.get(context);

          return Directionality(
            textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
            child: WillPopScope(
              child: Scaffold(
                appBar: defaultAppBar(
                  cubit: cubit,
                  actions:
                  [
                    Visibility(
                      visible: cubit.showHelpDialogs == true && [0,1,2].contains(cubit.currentBottomBarIndex),
                      child: IconButton(
                        icon: const Icon(Icons.question_mark),
                        onPressed: ()
                        {
                          switch (cubit.currentBottomBarIndex)
                          {
                            case 0: //Home

                            showDialog(
                              context: context,
                              builder: (dialogContext)
                              {
                                return defaultAlertDialog(
                                  context: dialogContext,
                                  title: Localization.translate('home_helper_title'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                      [
                                        Text(Localization.translate('home_helper_body1')),

                                        const SizedBox(height: 10,),

                                        Text(Localization.translate('home_helper_body2')),

                                        const SizedBox(height: 10,),

                                        Text(Localization.translate('home_helper_body2')),

                                        const SizedBox(height: 10,),

                                        Text(Localization.translate('home_helper_body4')),

                                        const SizedBox(height: 10,),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            );

                              break;

                            case 1: //Text File

                              showDialog(
                                  context: context,
                                  builder: (dialogContext)
                                  {
                                    return defaultAlertDialog(
                                      context: dialogContext,
                                      title: Localization.translate('textPage_helper_title'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children:
                                          [
                                            Text(Localization.translate('textPage_helper_body1')),

                                            const SizedBox(height: 10,),

                                            Text(Localization.translate('textPage_helper_body2')),

                                            const SizedBox(height: 10,),

                                            Text(Localization.translate('textPage_helper_body3')),

                                            const SizedBox(height: 10,),

                                            Text(Localization.translate('textPage_helper_body4'), style: const TextStyle(decoration: TextDecoration.underline)),

                                            const SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              );
                              break;

                            case 2: //Multimedia Files

                              showDialog(
                                  context: context,
                                  builder: (dialogContext)
                                  {
                                    return defaultAlertDialog(
                                      context: dialogContext,
                                      title: Localization.translate('multimediaPage_helper_title'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children:
                                          [
                                            Text(Localization.translate('multimediaPage_helper_body1')),

                                            const SizedBox(height: 10,),

                                            Text(Localization.translate('multimediaPage_helper_body2')),

                                            const SizedBox(height: 10,),

                                            Text(Localization.translate('multimediaPage_helper_body3')),

                                            const SizedBox(height: 10,),

                                            Text(Localization.translate('multimediaPage_helper_body4'), style: const TextStyle(decoration: TextDecoration.underline)),

                                            const SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              );

                              break;

                          }
                        },
                      ),
                    ),
                  ]
                ),

                body: cubit.bottomBarWidgets[cubit.currentBottomBarIndex],

                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: cubit.currentBottomBarIndex,

                  onTap: (index)
                  {
                    const Duration(milliseconds: 800);
                    cubit.changeBottomNavBar(index);
                  },

                  items:
                  [
                    BottomNavigationBarItem(label: Localization.translate('home_bnb'), icon: const Icon(Icons.rss_feed_rounded)),

                    BottomNavigationBarItem(label: Localization.translate('text_bnb') , icon: const Icon(Icons.text_snippet_rounded)),

                    BottomNavigationBarItem(label: Localization.translate('multimedia_bnb') ,icon: const Icon(Icons.video_collection_rounded)),

                    BottomNavigationBarItem(label: Localization.translate('bot_bnb') ,icon: const Icon(Icons.person_4_rounded)),

                    BottomNavigationBarItem(label: Localization.translate('profile_bnb') , icon: const Icon(Icons.person_rounded)),
                  ],

                ),

                resizeToAvoidBottomInset: false, //For Text File Page when adding text => won't resize itself
              ),

              onWillPop: ()async
              {
                return (
                    await showDialog(
                    context: context,
                    builder: (dialogContext)
                    {
                      return defaultAlertDialog(
                          context: dialogContext,
                          title: Localization.translate('exit_app_title'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children:
                              [
                                Text(Localization.translate('exit_app_secondary_title')),

                                const SizedBox(height: 5,),

                                Row(
                                  children:
                                  [
                                    TextButton(
                                        onPressed: ()=> exit(0), //Navigator.of(context).pop(true),
                                        child: Text(Localization.translate('exit_app_yes'))
                                    ),

                                    const Spacer(),

                                    TextButton(
                                      onPressed: ()=> Navigator.of(dialogContext).pop(false),
                                      child: Text(Localization.translate('exit_app_no')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    }
                )) ?? false;
              },
            ),
          );
        },

    );
  }


  //Manage App Life Cycles, if active in app (resumed) => Will re connect to webSocket if disconnected, otherwise will not
  @override
  void didChangeAppLifecycleState(AppLifecycleState state)
  {
    super.didChangeAppLifecycleState(state);

    switch(state)
    {
      case AppLifecycleState.resumed:
        isActive= true;
        break;

      case AppLifecycleState.detached:
        break;

      case AppLifecycleState.paused:
        Timer(const Duration(minutes: 1), ()
        {
          isActive= false;
        });

        break;

      case AppLifecycleState.inactive:
        break;
    }
  }



}
