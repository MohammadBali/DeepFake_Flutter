import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/Login/login.dart';
import 'package:deepfake_detection/modules/on_boarding/on_boarding_screen.dart';
import 'package:deepfake_detection/shared/bloc_observer.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/components/constants.dart';
import 'package:deepfake_detection/shared/network/end_points.dart';
import 'package:deepfake_detection/shared/network/local/cache_helper.dart';
import 'package:deepfake_detection/shared/network/remote/main_dio_helper.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:deepfake_detection/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'firebase_options.dart';
import 'layout/home_layout.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); //Makes sure that all the await and initializer get done before runApp


  //Firebase Settings & Connection

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  firebaseToken= await FirebaseMessaging.instance.getToken();
  //print('FIREBASE TOKEN: $firebaseToken');

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((event)
  {
    print('got firebase data');
    print(event.notification);
  }
  );

  //When user clicks the notification and it opens the app
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print('got firebase opened data');
    print(event.data.toString());

    defaultToast(msg: event.data.toString());
  }
  );

  //----------------------

  //WebSocket Connection Setup
  IOWebSocketChannel wsChannel= IOWebSocketChannel.connect(webSocketLocalHost, pingInterval: const Duration(seconds: 15));


  //Fire Flutter Errors into Run Terminal
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  //Set Directory For Files
  Directory appDocDir = await getApplicationDocumentsDirectory();
  //Set The Variable
  appDocPath=appDocDir.path;

  Bloc.observer = MyBlocObserver(); //Running Bloc Observer which prints change in states and errors etc...  in console

  //Dio Initialization
  MainDioHelper.init();


  await CacheHelper.init(); //Starting CacheHelper (SharedPreferences), await for it since there is async,await in .init().

  //Load Language
  AppCubit.language= CacheHelper.getData(key: 'language');
  AppCubit.language ??= 'en';
  await Localization.load(Locale(AppCubit.language!)); // Set the initial locale

  bool? isDark = CacheHelper.getData(key: 'isDarkTheme'); //Getting the last Cached ThemeMode
  isDark ??= true;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding'); //To get if OnBoarding screen has been shown before, if true then straight to Login Screen.
  onBoarding ??= false;


  if (CacheHelper.getData(key: 'token') != null) {
    token = CacheHelper.getData(key: 'token'); // Get User Token

    // if (JwtDecoder.isExpired(token) == true) //Check if token is expired or not
    // {
    //   print('Token is expired');
    //   token = '';
    // }
  }

  Widget widget; //to figure out which widget to send (login, onBoarding or HomePage) we use a widget and set the value in it depending on the token.

  if(onBoarding==true)
  {
    if (token.isNotEmpty) //Token is there, so Logged in before
    {
      widget = const HomeLayout(); //Straight to Home Page.
    }

    else
    {
      widget=Login();
    }
  }

  else //OnBoarding has been shown before but the token is empty => Login is required.
  {

    widget = const OnBoardingScreen();
  }

  runApp(MyApp(isDark: isDark, homeWidget: widget, wsChannel: wsChannel!,));
}

class MyApp extends StatelessWidget {

  final bool isDark;        //If the app last theme was dark or light
  final Widget homeWidget;  // Passing the widget to be loaded.

  final IOWebSocketChannel wsChannel; //Web Socket Channel to be received

  const MyApp({super.key, required this.isDark, required this.homeWidget, required this.wsChannel});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:
        [
          BlocProvider(create: (BuildContext  context)
          {
            //AppCubit.setListener(wsChannel);  //setListener(wsChannel)
            return AppCubit(wsChannel)..setListener()..changeTheme(themeFromState: isDark)..getUserData()..getPosts()..getUserPosts()..getNews()..getInquiries()..getSubscriptions()..getSubscriptionsPosts();
          }),
        ],
        child: BlocConsumer<AppCubit,AppStates>(
          listener: (context,state)
          {},

          builder: (context,state)
          {
            var cubit=AppCubit.get(context);

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              themeMode: AppCubit.get(context).isDarkTheme   //If the boolean says last used is dark (from Cache Helper) => Then load dark theme
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: Directionality(
                textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
                child: AnimatedSplashScreen(
                  duration: 3000,
                  animationDuration: const Duration(milliseconds: 200),
                  splash: Image(
                    image: AssetImage(
                      cubit.isDarkTheme? 'assets/images/splash/dark_logo.png' : 'assets/images/splash/light_logo.png',
                    ),
                    fit: BoxFit.contain,
                    width: 150,
                    height: 150,
                  ),
                  splashIconSize: 150,
                  nextScreen: homeWidget,
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.fade,
                  backgroundColor: cubit.isDarkTheme? defaultHomeDarkColor : defaultHomeColor,

                ),
              ),
            );
          },
        )
    );
  }
}
