import 'dart:convert';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/models/AUserPostsModel/AUserPostsModel.dart';
import 'package:deepfake_detection/models/InquiryModel/InquiryModel.dart';
import 'package:deepfake_detection/models/NewsModel/NewsModel.dart';
import 'package:deepfake_detection/models/PostModel/PostModel.dart';
import 'package:deepfake_detection/models/SubscriptionsModel/SubscriptionsModel.dart';
import 'package:deepfake_detection/models/UserDataModel/UserDataModel.dart';
import 'package:deepfake_detection/modules/ChatBot/chatBot.dart';
import 'package:deepfake_detection/modules/Home/home.dart';
import 'package:deepfake_detection/modules/Login/login.dart';
import 'package:deepfake_detection/modules/Profile/profile.dart';
import 'package:deepfake_detection/modules/TextFiles/text_files.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/components/constants.dart';
import 'package:deepfake_detection/shared/network/end_points.dart';
import 'package:deepfake_detection/shared/network/local/cache_helper.dart';
import 'package:deepfake_detection/shared/network/remote/main_dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_socket_channel/io.dart';

class AppCubit extends Cubit<AppStates>
{
  final IOWebSocketChannel wsChannel;
  AppCubit(this.wsChannel): super(AppInitialState());

  static AppCubit get(context)=> BlocProvider.of(context);

  //SET LISTENER FOR WEB SOCKETS
   void setListener(IOWebSocketChannel wsChannel) {
    wsChannel.stream.listen((message) {
      //Parse JSON from String
      var jsonMessage= jsonDecode(message);

      if(jsonMessage['posts']!=null)
        {
          print('Got WS Message!, ${jsonMessage['type']}');

          Post post= Post.fromJson(jsonMessage['posts']);

          switch (jsonMessage['type'])
          {
            case 'like':
              wsLike(post);
              break;

            case 'add_comment':
              wsComments(post);
              break;

            case 'delete_comment':
              wsComments(post);
              break;

            case 'delete_post':
              wsDeletePost(post);
              break;

            default:
              print('WS Message Does not convey any types');
              break;

          }

        }

      else
        {
          print(jsonMessage);
        }


    });
  }


  //WEB SOCKETS

  //Modify Likes
  void wsLike(Post post)
  {
    print('Add/Remove Like WS');

    if(postModel !=null)
      {
        int indexOfElement=-1;

        emit(AppWSAddLikePostModelLoadingState());

        try {
          for (var element in postModel!.posts!)
          {
            if(element.id! == post.id!)
            {
              print('Found Post, Modifying it now...');
              indexOfElement=postModel!.posts!.indexOf(element);
            }
          }

          if(indexOfElement != -1)
            {
              postModel!.posts![indexOfElement]=post;
              emit(AppWSAddLikePostModelSuccessState(post));
            }
          else
            {
              print('Post Was not found => adding it now...');
              postModel!.posts!.add(post);
              emit(AppWSAddLikePostModelSuccessState(post));
            }
        }catch (error,stackTrace) {
          print('ERROR WHILE MODIFYING LIKES POSTS IN POST-MODEL WS,${error.toString()} , $stackTrace');
          emit(AppWSAddLikePostModelErrorState());
        }

      }

    else
      {
        print('Could not modify likes, Post Model is Null');
      }

    if(subscriptionsPostsModel !=null)
    {
        int indexOfElement=-1;

        emit(AppWSAddLikeSubscriptionsPostsModelLoadingState());

        try {
          for (var element in subscriptionsPostsModel!.posts!)
          {
            if(element.id! == post.id!)
            {
              print('Found Post in Subscriptions Post Model, Modifying it now...');
              indexOfElement=subscriptionsPostsModel!.posts!.indexOf(element);
            }
          }

          if(indexOfElement != -1)
          {
            subscriptionsPostsModel!.posts![indexOfElement]=post;
            emit(AppWSAddLikeSubscriptionsPostsModelSuccessState());
          }

          else
            {
              print('Post Was not found in Subscriptions Post Model=> do nothing..');
              emit(AppWSAddLikeSubscriptionsPostsModelSuccessState());
            }
        }catch (error,stackTrace) {
          print('ERROR WHILE MODIFYING LIKES POSTS IN SUBSCRIPTIONS-POST-MODEL WS,${error.toString()} , $stackTrace');
          emit(AppWSAddLikeSubscriptionsPostsModelErrorState());
        }
      }

    else
    {
      print('Could not modify likes, Subscriptions Post Model is Null');
    }


    if(aUserPostsModel !=null)
      {
        int indexOfElement=-1;

        emit(AppWSAddLikeAUserPostsModelLoadingState());

        try {
          for (var element in aUserPostsModel!.posts!)
          {
            if(element.id! == post.id!)
            {
              print('Found Post in Subscriptions Post Model, Modifying it now...');
              indexOfElement=aUserPostsModel!.posts!.indexOf(element);
            }
          }

          if(indexOfElement != -1)
          {
            aUserPostsModel!.posts![indexOfElement]=post;
            emit(AppWSAddLikeAUserPostsModelSuccessState());
          }

          else
          {
            print('Post Was not found in A USER Post Model=> do nothing..');
            emit(AppWSAddLikeAUserPostsModelSuccessState());
          }
        }catch (error,stackTrace) {
          print('ERROR WHILE MODIFYING LIKES POSTS IN A-USER-POST-MODEL WS,${error.toString()} , $stackTrace');
          emit(AppWSAddLikeAUserPostsModelErrorState());
        }
      }
    else
      {
        print('Could not modify likes, A User Post Model is Null');
      }
  }

  //Modify Comments
  void wsComments(Post post)
  {
    print('Add/Remove Comments WS');

    if(postModel !=null)
    {
      int indexOfElement=-1;

      emit(AppWSModifyCommentPostModelLoadingState());

      try {
        for (var element in postModel!.posts!)
        {
          if(element.id! == post.id!)
          {
            print('Found Post, Modifying it now...');
            indexOfElement=postModel!.posts!.indexOf(element);
          }
        }

        if(indexOfElement != -1)
        {
          postModel!.posts![indexOfElement]=post;
          emit(AppWSModifyCommentPostModelSuccessState(post));

        }

        else
          {
            print('Post Was not found => adding it now...');
            postModel!.posts!.add(post);
            emit(AppWSModifyCommentPostModelSuccessState(post));
          }
      }catch (error,stackTrace) {
        print('ERROR WHILE MODIFYING COMMENTS POSTS WS,${error.toString()} , $stackTrace');
        emit(AppWSModifyCommentPostModelErrorState());
      }

    }

    else
    {
      print('Could not modify Comments, Post Model is Null');
    }

    if(subscriptionsPostsModel !=null)
    {
      int indexOfElement=-1;

      emit(AppWSModifyCommentSubscriptionsPostsModelLoadingState());

      try {
        for (var element in subscriptionsPostsModel!.posts!)
        {
          if(element.id! == post.id!)
          {
            print('Found Post in Subscriptions Post Model, Modifying it now...');
            indexOfElement=subscriptionsPostsModel!.posts!.indexOf(element);
          }
        }

        if(indexOfElement != -1)
        {
          subscriptionsPostsModel!.posts![indexOfElement]=post;
          emit(AppWSModifyCommentSubscriptionsPostsModelSuccessState());
        }
        else
          {
            print('Post Was not found in Subscriptions Post Model=> do nothing..');
            emit(AppWSModifyCommentSubscriptionsPostsModelSuccessState());
          }

      }catch (error,stackTrace) {
        print('ERROR WHILE MODIFYING COMMENTS POSTS IN SUBSCRIPTIONS-POST-MODEL WS,${error.toString()} , $stackTrace');
        emit(AppWSModifyCommentSubscriptionsPostsModelErrorState());
      }
    }

    else
    {
      print('Could not modify Comments, Subscriptions Post Model is Null');
    }


    if(aUserPostsModel !=null)
    {
      int indexOfElement=-1;

      emit(AppWSModifyCommentAUserPostsModelLoadingState());

      try {
        for (var element in aUserPostsModel!.posts!)
        {
          if(element.id! == post.id!)
          {
            print('Found Post in Subscriptions Post Model, Modifying it now...');
            indexOfElement=aUserPostsModel!.posts!.indexOf(element);
          }
        }

        if(indexOfElement != -1)
        {
          aUserPostsModel!.posts![indexOfElement]=post;
          emit(AppWSModifyCommentAUserPostsModelSuccessState());
        }
        else
        {
          print('Post Was not found in A User Post Model=> do nothing..');
          emit(AppWSModifyCommentAUserPostsModelSuccessState());
        }

      }catch (error,stackTrace) {
        print('ERROR WHILE MODIFYING COMMENTS POSTS IN A-USER-POST-MODEL WS,${error.toString()} , $stackTrace');
        emit(AppWSModifyCommentAUserPostsModelErrorState());
      }
    }

    else
    {
      print('Could not modify Comments, A User Post Model is Null');
    }
  }

  //Delete Post
  void wsDeletePost(Post post)
  {
    print('Remove a Post WS');

    if(postModel !=null)
    {
      int indexOfElement=-1;
      emit(AppWSDeletePostPostModelLoadingState());
      try {
        for (var element in postModel!.posts!)
        {
          if(element.id! == post.id!)
          {
            print('Found Post, Deleting it now...');
            indexOfElement=postModel!.posts!.indexOf(element);

          }
        }

        if(indexOfElement != -1)
          {
            postModel!.posts!.removeAt(indexOfElement);
            emit(AppWSDeletePostPostModelSuccessState(post));
          }
        else
          {
            print('Post Does not exist to delete it...');
            emit(AppWSDeletePostPostModelSuccessState(post));
          }
      }catch (error,stackTrace) {
        print('ERROR WHILE DELETING POST POSTS WS,${error.toString()} , $stackTrace');
        emit(AppWSDeletePostPostModelErrorState());
      }

    }

    else
    {
      print('Could not delete post, Post Model is Null');
    }


    if(subscriptionsPostsModel !=null)
    {
      int indexOfElement=-1;
      emit(AppWSDeletePostSubscriptionsPostsModelLoadingState());
      try {
        for (var element in postModel!.posts!)
        {
          if(element.id! == post.id!)
          {
            print('Found Post in Subscriptions Post Model, Deleting it now...');
            indexOfElement=postModel!.posts!.indexOf(element);

          }
        }

        if(indexOfElement != -1) {
          postModel!.posts!.removeAt(indexOfElement);
          emit(AppWSDeletePostSubscriptionsPostsModelSuccessState());
          return;
        }
        else
          {
            print('Post Does not exist to delete it...');
            emit(AppWSDeletePostSubscriptionsPostsModelSuccessState());
          }
      }catch (error,stackTrace) {
        print('ERROR WHILE DELETING POST POSTS WS,${error.toString()} , $stackTrace');
        emit(AppWSDeletePostSubscriptionsPostsModelErrorState());
      }

    }

    else
    {
      print('Could not delete post, Subscriptions Post Model is Null');
    }


    if(aUserPostsModel !=null)
    {
      int indexOfElement=-1;
      emit(AppWSDeletePostAUserPostsModelLoadingState());
      try {
        for (var element in aUserPostsModel!.posts!)
        {
          if(element.id! == post.id!)
          {
            print('Found Post in A User Post Model, Deleting it now...');
            indexOfElement=aUserPostsModel!.posts!.indexOf(element);

          }
        }

        if(indexOfElement != -1) {
          aUserPostsModel!.posts!.removeAt(indexOfElement);
          emit(AppWSDeletePostAUserPostsModelSuccessState());
          return;
        }
        else
        {
          print('Post Does not exist to delete it...');
          emit(AppWSDeletePostAUserPostsModelSuccessState());
        }
      }catch (error,stackTrace) {
        print('ERROR WHILE DELETING POST IN A-USER-POSTS-MODEL WS,${error.toString()} , $stackTrace');
        emit(AppWSDeletePostAUserPostsModelErrorState());
      }

    }

    else
    {
      print('Could not delete post, A User Post Model is Null');
    }
  }


  //Send Data to Server by WebSockets
  void addLike({required String userID, required String postID})
  {
    Map<String,dynamic> data=
    {
      'type':'like',
      'userID':userID,
      'postID':postID,
      'token':token
    };

    wsChannel.sink.add(jsonEncode(data));
  }



  //Send Comment to Server by WebSockets
  void addComment({required String userID, required String postID, required String comment})
  {
    Map<String,dynamic> data=
    {
      'type':'comment',
      'userID':userID,
      'postID':postID,
      'comment':comment,
      'token':token
    };

    wsChannel.sink.add(jsonEncode(data));

    defaultToast(msg: Localization.translate('comment_add_successfully_toast'));
  }

  //-----------------------------------


  //GLOBAL SETTINGS

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

  //DARK MODE
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

  //-----------------------------------


  //Current Language Code

  static String? language='';

  //Change Language
  void changeLanguage(String lang) async
  {
    language=lang;
    emit(AppChangeLanguageState());
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

          print('got UserData...');

          userData=UserData.fromJson(value.data);

          emit(AppGetUserDataSuccessState());
        }).catchError((error){
          print('ERROR WHILE GETTING USER DATA, ${error.toString()}');

          emit(AppGetUserDataErrorState());
        });
      }
  }


  //Update User Profile
  void updateUserProfile({String? firstName, String? lastName , String? email, String? photo})
  {
    String? n, ln, e, p;
    firstName==null || firstName=='' ? n=null : firstName==userData!.name! ? n=null : n=firstName ; //If passed Name is null => store null in n and don't pass it to API, otherwise put the data

    lastName==null || lastName=='' ? ln=null : lastName==userData!.lastName! ? ln=null : ln=lastName ;

    email==null || email=='' ? e=null : email==userData!.email! ? e=null : e=email;

    photo==null ? p=null : photo==userData!.photo! ? p=null : p=photo;

    print('Data to update name: $n  email: $e  photo: $p');

    if(n==null && ln==null && e==null && p==null)
      {
        defaultToast(msg: Localization.translate('update_user_profile_no_data_toast'));
      }

    else
      {
        emit(AppUpdateUserProfileLoadingState());

        MainDioHelper.patchData(
          url: updateUser,
          token: token,
          data: {
            if(n!=null) 'name':n,
            if(ln!=null) 'last_name':ln,
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


  SubscriptionsModel? subscriptionsModel;
  void getSubscriptions()
  {
    if(token!='')
      {
        print('In Getting Subscriptions');
        emit(AppGetUserSubscriptionsLoadingState());

        MainDioHelper.getData(
          url: subscriptions,
          token: token,
        ).then((value) {
          print('Got Subscriptions Data...');

          subscriptionsModel=SubscriptionsModel.fromJson(value.data);

          emit(AppGetUserSubscriptionsSuccessState());
        }).catchError((error,stackTrace)
        {
          print('ERROR WHILE GETTING SUBSCRIPTIONS, ${error.toString()} $stackTrace');
          print(AppGetUserSubscriptionsErrorState);
        });
      }
  }


  // Add a user to subscriptions or remove him.
  void manageSubscriptions(String userId)
  {
    print('In Managing Subscriptions...');
    emit(AppManageSubscriptionsLoadingState());
    
    MainDioHelper.postData(
      url: '$manageSubs/$userId',
      data: {},
      token: token
    ).then((value) {
      print('Got Managing Subscriptions Data..., ${value.data}');

      subscriptionsModel=SubscriptionsModel.fromJson(value.data['user']);

      emit(AppManageSubscriptionsSuccessState());

    }).catchError((error)
    {
      print('ERROR WHILE MANAGING SUBSCRIPTIONS, ${error.toString()}');
      emit(AppManageSubscriptionsErrorState());
    });
  }

  //Logout User and Remove his token from back-end side
  bool logout({required BuildContext context})
  {
    emit(AppLogoutLoadingState());

    MainDioHelper.postData(
      url: logoutOneToken,
      data: {},
      token: token,
    ).then((value) {

      CacheHelper.saveData(key: 'token', value: '').then((value)
      {
        token='';
        userData=null;
        postModel=null;
        inquiryModel=null;
        userPostsModel=null;
        currentBottomBarIndex=0;
        defaultToast(msg: Localization.translate('logout_successfully_toast'));

        navigateAndFinish(context, Login());
        emit(AppLogoutSuccessState());

        return true;

      }).catchError((error)
      {
        defaultToast(msg: error.toString());
        print('ERROR WHILE LOGGING OUT CACHE HELPER, ${error.toString()}');
        emit(AppLogoutErrorState());
        return false;
      });

    }).catchError((error)
    {
      print('ERROR WHILE LOGGING OUT, ${error.toString()}');
      emit(AppLogoutErrorState());
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

      print('Got News Data...');

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

  //Check for New Posts & Merge Together => Guess Need to ask for all posts and keep them, maybe some posts got deleted ?
  PostModel? newPostModel;
  Future<void> checkForNewPosts()async
  {

    getPosts();

    getSubscriptionsPosts();

    // print('In Check For New Posts...');
    // emit(AppCheckNewPostsLoadingState());
    //
    // MainDioHelper.getData(
    //   url: posts,
    //   token: token,
    // ).then((value){
    //
    //   print('Got Check For New Posts Data...');
    //
    //   newPostModel=PostModel.fromJson(value.data);
    //
    //   bool isFound=false;
    //   for (var newPost in newPostModel!.posts!)
    //   {
    //     for(var oldPost in postModel!.posts!)
    //       {
    //         if(newPost.id! == oldPost.id!)
    //           {
    //             isFound=true;
    //           }
    //       }
    //
    //     if(isFound==false)
    //       {
    //         postModel!.posts!.add(newPost);
    //       }
    //     isFound=false;
    //   }
    //
    //   emit(AppCheckNewPostsSuccessState());
    // }).catchError((error)
    // {
    //   print('ERROR WHILE CHECKING FOR NEW POSTS, ${error.toString()}');
    //
    //   emit(AppCheckNewPostsErrorState());
    // });

  }

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
            //print('Adding New Post');

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

  //A Helper Function for GetNextPosts
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


  //Get User Posts
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


  PostModel? subscriptionsPostsModel;
  void getSubscriptionsPosts()
  {
    if(token!='')
      {
        print('In Getting Subscriptions Posts..');
        emit(AppGetSubscriptionsLoadingState());

        MainDioHelper.getData(
            url: subscriptionsPosts,
            token:token
        ).then((value) {

          print('Got Subscriptions Data...');

          subscriptionsPostsModel=PostModel.fromJson(value.data);
          emit(AppGetSubscriptionsSuccessState());
        }).catchError((error)
        {
          print('ERROR WHILE GETTING SUBSCRIPTIONS POSTS, ${error.toString()}');
          emit(AppGetSubscriptionsErrorState());
        });
      }
  }
  
  //Got Some User Posts Through his ID
  AUserPostsModel? aUserPostsModel;
  
  void getAUserPosts(String userId)
  {
    print('In Getting A User Posts');
    
    emit(AppGetAUserPostsLoadingState());
    
    MainDioHelper.getData(
      url: '$getSomeUserPosts/$userId',
      token: token,
    ).then((value) {

      print('Got A User Data...');

      aUserPostsModel=AUserPostsModel.fromJson(value.data);

      emit(AppGetAUserPostsSuccessState());
    }).catchError((error)
    {
      print('ERROR WHILE GETTING A USER POSTS, ${error.toString()}');
      emit(AppGetAUserPostsErrorState());
    });
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


  //Upload a Text Inquiry

  Future<bool> uploadTextInquiry( {required PlatformFile file, void Function(int, int)? onSendProgress}) async
  {
    bool boolToReturn=false;

    if(file.size <= maxTextFileSize)
      {

        print('In Uploading Text Inquiry...');
        emit(AppUploadTextInquiryLoadingState());

        //Set Data to be sent as Map
        final formData=FormData.fromMap(
            {
              'type':file.extension,
              'name':file.name,
              'result':'true', //TBD, Must be returned by back-end through AI Model
              'text': await MultipartFile.fromFile(file.path!, filename: file.name),
            });

        MainDioHelper.postFileData(
          url: addTextInquiry,
          data:formData,
          token: token,
          onSendProgress: onSendProgress,

        ).then((value) {

          print('Got UploadTextInquiry Data...');

          emit(AppUploadTextInquirySuccessState());



          getInquiries(); //Ask For New Inquiries

          boolToReturn=true;

          defaultToast(msg: Localization.translate('upload_text_inquiry_successfully_toast'));

        }).catchError((error)
        {
          print('ERROR WHILE UPLOADING TEXT INQUIRY, ${error.toString()}');
          emit(AppUploadTextInquiryErrorState());

          boolToReturn=false;
        });

        return boolToReturn;
      }

    else
      {
        defaultToast(msg: '${Localization.translate('big_file_size_toast')}, ${byteToMB(maxTextFileSize)} MB', length: Toast.LENGTH_LONG);
        return false;
      }
  }

 //----------------------------------------------

  //FILE PICKER

  PlatformFile? chosenFile;

  void pickFile() async
  {
    emit(AppGetFileLoadingState());

    try {
      FilePickerResult? result= await FilePicker.platform.pickFiles(allowedExtensions: ['docx','pdf','doc','txt'], type: FileType.custom, allowMultiple: false, );
      if(result !=null)
      {
        chosenFile=result.files.first;

        emit(AppGetFileSuccessState());
      }
      else
      {
        print('FILE PICKER RESULT IS NULL');
        emit(AppGetFileErrorState());
      }


    }catch (e)
    {
      print('ERROR WHILE PICKING A FILE, ${e.toString()}');

      defaultToast(msg: e.toString());
      emit(AppGetFileErrorState());
    }
  }


  void removeFile()
  {
    chosenFile=null;
    emit(AppRemoveFileState());
  }
}