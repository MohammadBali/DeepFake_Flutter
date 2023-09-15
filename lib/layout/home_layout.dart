import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit= AppCubit.get(context);
          return Scaffold(
            appBar: defaultAppBar(cubit: cubit),

            body: cubit.bottomBarWidgets[cubit.currentBottomBarIndex],

            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentBottomBarIndex,

              onTap: (index)
              {
                const Duration(milliseconds: 800);
                cubit.changeBottomNavBar(index);
              },

              items:
              const [
                BottomNavigationBarItem(label: 'Home' , icon: Icon(Icons.rss_feed_rounded)),

                BottomNavigationBarItem(label: 'Text' , icon: Icon(Icons.file_present_rounded)),

                BottomNavigationBarItem(label: 'Bot' ,icon: Icon(Icons.person_4_rounded)),

                BottomNavigationBarItem(label: 'Profile' , icon: Icon(Icons.person_rounded)),
              ],

            ),
          );
        },

    );
  }
}
