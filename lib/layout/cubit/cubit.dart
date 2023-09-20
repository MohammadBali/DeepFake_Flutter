import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/InquiryModel/InquiryModel.dart';
import 'package:deepfake_detection/models/NewsModel/NewsModel.dart';
import 'package:deepfake_detection/models/PostModel/PostModel.dart';
import 'package:deepfake_detection/models/UserDataModel/UserDataModel.dart';
import 'package:deepfake_detection/modules/ChatBot/chatBot.dart';
import 'package:deepfake_detection/modules/Home/home.dart';
import 'package:deepfake_detection/modules/Login/login.dart';
import 'package:deepfake_detection/modules/Profile/profile.dart';
import 'package:deepfake_detection/modules/TextFiles/text_files.dart';
import 'package:deepfake_detection/shared/components/components.dart';
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
    Home(),
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


  //USER APIS

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


  //Update User Profile
  void updateUserProfile({String? name, String? email, String? photo})
  {
    String? n,e,p;
    name==null || name=='' ? n=null : name==userData!.name! ? n=null : n=name ; //If passed Name is null => store null in n and don't pass it to API, otherwise put the data

    email==null || email=='' ? e=null : email==userData!.email! ? e=null : e=email;

    photo==null ? p=null : photo==userData!.photo! ? p=null : p=photo;

    print('Data to update name: $n  email: $e  photo: $p');

    if(n==null && e==null && p==null)
      {
        defaultToast(msg: 'No Data to Update');
      }

    else
      {
        emit(AppUpdateUserProfileLoadingState());

        MainDioHelper.patchData(
          url: updateUser,
          token: token,
          data: {
            if(n!=null) 'name':n,
            if(e!=null) 'email':e,
            if(p!=null) 'photo':p,
          },
        ).then((value){
          print('Got Updated User Data, ${value.data}');

          userData=UserData.fromJson(value.data);

          emit(AppUpdateUserProfileSuccessState());
        }).catchError((error)
        {
          print('ERROR WHILE PATCHING USER DATA, ${error.toString()}');
          emit(AppUpdateUserProfileErrorState(error.toString()));

        });
      }
  }

  PostModel? userPostsModel;

  void getUserPosts()
  {
    if(token!='')
      {
        print("In Getting User's Posts");
        emit(AppGetUserPostsLoadingState());
        MainDioHelper.getData(
          url: userPosts,
          token: token,
        ).then((value) {
          print('Got User Posts');
          userPostsModel=PostModel.fromJson(value.data,isOwnerUser: true);
          emit(AppGetUserPostsSuccessState());
        }).catchError((error)
        {
          print('ERROR WHILE GETTING USER POSTS, ${error.toString()}');
          emit(AppGetUserPostsErrorState());
        });
      }
  }

  //Logout User
  bool logout({required BuildContext context})
  {

    CacheHelper.saveData(key: 'token', value: '').then((value)
    {
      token='';
      userData=null;
      postModel=null;
      inquiryModel=null;
      currentBottomBarIndex=0;
      defaultToast(msg: 'Logged Out');

      navigateAndFinish(context, Login());
      emit(AppLogoutState());

      return true;

    }).catchError((error)
    {
      defaultToast(msg: error.toString());
      print('ERROR WHILE LOGGING OUT, ${error.toString()}');

      return false;
    });

    return false;
  }

  //------------------------------------------


  //NEWS APIS

  //Get News
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


  //--------------------------------------------


  //POSTS APIS

  //Get Posts
  static PostModel? postModel;

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
          print('Got Posts Data');
          postModel=PostModel.fromJson(value.data);

          emit(AppGetPostsSuccessState());
        }).catchError((error)
        {
          print('ERROR WHILE GETTING POSTS, ${error.toString()}');

          emit(AppGetPostsErrorState());
        });
      }
  }

  //Upload a Post
  void uploadPost({required String inquiryId, required String comment, required String ownerId})
  {
    print('In Uploading a Post...');
    emit(AppUploadPostLoadingState());

    MainDioHelper.postData(
      url: addPost,
      isStatusCheck: true,
      data:
      {
        "inquiry":inquiryId,
        "owner":ownerId,
        "title":comment
      },
      token: token,
    ).then((value) {
      print('Got Upload Data...');

      if(value.data['success'] ==0)
        {
          print('ERROR WHILE UPLOADING A POST AND SUCCESS=0, ${value.data['message']}');
          emit(AppUploadPostErrorState(value.data['message']));
        }

      else
        {
          getUserPosts();
          print('Added Successfully');

          emit(AppUploadPostSuccessState());
        }
    }).catchError((error)
    {
      print('ERROR WHILE UPLOADING A POST, ${error.toString()}');
      emit(AppUploadPostErrorState(error.toString()));
    });
  }

  //Will get the next new posts when scrolled and will add them to postModel
  void getNextPosts({required String? nextPage})
  {
    if(nextPage !=null)
      {
        emit(AppGetNewPostsLoadingState());

        MainDioHelper.getData(
          url: '$posts$nextPage',
          token: token,
        ).then((value){

          //print('Got Posts Data, ${value.data}');

          value.data['posts'].forEach((post)
          {
            print('Adding New Post');

            //postModel?.posts?.add(Post.fromJson(post));

            nextPostAdder(Post.fromJson(post));

            postModel?.pagination= Pagination.fromJson(value.data['pagination']);
          });

          emit(AppGetNewPostsSuccessState());
        }).catchError((error)
        {
          print('ERROR WHILE GETTING NEW POSTS, ${error.toString()}');

          emit(AppGetNewPostsErrorState());
        });
      }

    else
      {
        print('NextPage is Null');
      }
  }


  int nextPostAdder(Post post)
  {
    try
    {
      for (var p in postModel!.posts!)
      {
        if(post.id! == p.id!)
        {
          return -1;
        }
      }
      postModel?.posts?.add(post);
      return 1;
    }
    catch(e)
    {
      print('ERROR IN NEXT POST ADDER, ${e.toString()}');
      return -2;
    }
  }


  //Send API to delete from Back-end and then delete it from userPostsModel.
  void deletePost(String postId)
  {
    print('In Delete Post with ID:$postId');
    emit(AppDeleteAPostLoadingState());

    MainDioHelper.deleteData(
      url: '$deleteAPost/$postId',
      data: {},
      token: token,
    ).then((value) {

      print('Got Delete a Post Data...');

      Post? toBeDeleted;

      for (var post in userPostsModel!.posts!)
      {
        if(post.id! == postId)
          {
            toBeDeleted=post;
          }
      }

      if(toBeDeleted !=null)
        {
          userPostsModel!.posts!.remove(toBeDeleted);
          print('Deleted post from userPostsModel');
        }

      emit(AppDeleteAPostSuccessState());

    }).catchError((error)
    {
      print('ERROR WHILE DELETING A POST, ${error.toString()}');
      emit(AppDeleteAPostErrorState(error.toString()));
    });
  }

  //-----------------------------------------


  //INQUIRIES API

  InquiryModel? inquiryModel;

  void getInquiries()
  {
    if(token != '')
      {
        print('Getting User Inquiries...');
        emit(AppGetInquiriesLoadingState());

        MainDioHelper.getData(
          url: getUserInquiries,
          token: token,
        ).then((value) {
          print('Got User Inquiries...');

          inquiryModel=InquiryModel.fromJson(value.data);

          emit(AppGetInquiriesSuccessState());
        }).catchError((error)
        {
          print('ERROR WHILE GETTING USER INQUIRIES, ${error.toString()}');

          emit(AppGetInquiriesErrorState());
        });
      }
  }


  //Delete an Inquiry
  void deleteInquiry(String inquiryId)
  {
    print('In Delete Inquiry, Id is: $inquiryId');
    emit(AppDeleteInquiryLoadingState());

    MainDioHelper.deleteData(
      url: '$deleteUserInquiry/$inquiryId',
      data: {},
      token: token,
    ).then((value) {
      print('Got Deleted Inquiry Data...');

      Inquiry? toBeDeleted;

      for (var inquiry in inquiryModel!.inquiries!)
      {
        if(inquiry.id! == inquiryId)
        {
          toBeDeleted=inquiry;
        }
      }

      if(toBeDeleted !=null)
      {
        inquiryModel!.inquiries!.remove(toBeDeleted);
        print('Deleted inquiry from inquiryModel');

        getUserPosts();
      }

      emit(AppDeleteAPostSuccessState());
    }).catchError((error)
    {
      print('ERROR WHILE DELETING AN INQUIRY, ${error.toString()}');
      emit(AppDeleteInquiryErrorState(error.toString()));
    });
  }

 //----------------------------------------------



}