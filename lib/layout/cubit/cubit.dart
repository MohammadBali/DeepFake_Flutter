import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/NewsModel/NewsModel.dart';
import 'package:deepfake_detection/models/PostModel/PostModel.dart';
import 'package:deepfake_detection/models/UserDataModel/UserDataModel.dart';
import 'package:deepfake_detection/modules/ChatBot/chatBot.dart';
import 'package:deepfake_detection/modules/Home/home.dart';
import 'package:deepfake_detection/modules/Profile/profile.dart';
import 'package:deepfake_detection/modules/TextFiles/text_files.dart';
import 'package:deepfake_detection/shared/components/constants.dart';
import 'package:deepfake_detection/shared/network/end_points.dart';
import 'package:deepfake_detection/shared/network/local/cache_helper.dart';
import 'package:deepfake_detection/shared/network/remote/main_dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit(): super(AppInitialState());

  static AppCubit get(context)=> BlocProvider.of(context);

  List<Widget> bottomBarWidgets=
  [
    const Home(),
    const TextFiles(),
    const ChatBot(),
    const Profile(),
  ];

  int currentBottomBarIndex = 0;

  void changeBottomNavBar(int index) {
    currentBottomBarIndex = index;

    emit(AppChangeBottomNavBar());
  }

  bool isDarkTheme = false; //Check if the theme is Dark.

  void changeTheme({bool? themeFromState}) {
    if (themeFromState != null) //if a value is sent from main, then use it.. we didn't use CacheHelper because the value has already came from cache, then there is no need to..
        {
      isDarkTheme = themeFromState;
      emit(AppChangeThemeModeState());
    } else // else which means that the button of changing the theme has been pressed.
        {
      isDarkTheme = !isDarkTheme;
      CacheHelper.putBoolean(key: 'isDarkTheme', value: isDarkTheme).then((value) //Put the data in the sharedPref and then emit the change.
      {
        emit(AppChangeThemeModeState());
      });
    }
  }


  //Get User Data by Token.
  static UserData? userData;

  void getUserData()
  {
    if(token !='')
      {
        print('In Getting User Data');
        emit(AppGetUserDataLoadingState());

        MainDioHelper.getData(
          url: getUserDataByToken,
          token: token,
        ).then((value){

          print('got UserData, ${value.data}');

          userData=UserData.fromJson(value.data);

          emit(AppGetUserDataSuccessState());
        }).catchError((error){
          print('ERROR WHILE GETTING USER DATA, ${error.toString()}');

          emit(AppGetUserDataErrorState());
        });
      }
  }


  NewsModel? newsModel;

  void getNews()
  {
    print('In Getting News...');

    emit(AppGetNewsLoadingState());

    MainDioHelper.getData(
      url: news,
    ).then((value) {

      print('Got News Data, ${value.data}');

      newsModel= NewsModel.fromJson(value.data);

      emit(AppGetNewsSuccessState());

    }).catchError((error)
    {
      print('ERROR WHILE GETTING NEWS, ${error.toString()}');

      emit(AppGetNewsErrorState());
    });
  }


  PostModel? postModel;
  void getPosts()
  {
    if(token !='')
      {
        print('In Getting Posts...');

        emit(AppGetPostsLoadingState());

        MainDioHelper.getData(
            url: posts,
            token: token,
        ).then((value){

          print('Got Posts Data, ${value.data}');

          postModel=PostModel.fromJson(value.data);

          emit(AppGetPostsSuccessState());
        }).catchError((error)
        {
          print('ERROR WHILE GETTING POSTS, ${error.toString()}');

          emit(AppGetPostsErrorState());
        });

      }

  }


}