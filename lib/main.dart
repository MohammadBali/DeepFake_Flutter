import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/Login/login.dart';
import 'package:deepfake_detection/modules/on_boarding/on_boarding_screen.dart';
import 'package:deepfake_detection/shared/bloc_observer.dart';
import 'package:deepfake_detection/shared/components/constants.dart';
import 'package:deepfake_detection/shared/network/local/cache_helper.dart';
import 'package:deepfake_detection/shared/network/remote/main_dio_helper.dart';
import 'package:deepfake_detection/shared/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'layout/home_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Makes sure that all the await and initializer get done before runApp

  Bloc.observer = MyBlocObserver(); //Running Bloc Observer which prints change in states and errors etc...  in console

  MainDioHelper.init();

  await CacheHelper.init(); //Starting CacheHelper, await for it since there is async,await in .init().

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

  runApp(MyApp(isDark: isDark, homeWidget: widget,));
}

class MyApp extends StatelessWidget {

  final bool isDark;        //If the app last theme was dark or light
  final Widget homeWidget;  // Passing the widget to be loaded.


  const MyApp({super.key, required this.isDark, required this.homeWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:
        [
          BlocProvider(create: (BuildContext  context) => AppCubit()..changeTheme(themeFromState: isDark)..getUserData() ),
        ],
        child: BlocConsumer<AppCubit,AppStates>(
          listener: (context,state){},
          builder: (context,state)
          {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              themeMode: AppCubit.get(context).isDarkTheme   //If the boolean says last used is dark (from Cache Helper) => Then load dark theme
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: homeWidget,
            );
          },
        )
    );
  }
}
