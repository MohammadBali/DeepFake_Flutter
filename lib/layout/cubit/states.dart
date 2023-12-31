import 'package:deepfake_detection/models/PostModel/PostModel.dart';

abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeBottomNavBar extends AppStates{}

class AppChangeThemeModeState extends AppStates{}

class AppChangeLanguageState extends AppStates{}

class AppChangeHelpState extends AppStates{}

//-----------------------------------------------

//GET USER DATA

class AppGetUserDataLoadingState extends AppStates{}

class AppGetUserDataSuccessState extends AppStates{}

class AppGetUserDataErrorState extends AppStates{}


//-----------------------------------------------


//GET USER POSTS

class AppGetUserPostsLoadingState extends AppStates{}

class AppGetUserPostsSuccessState extends AppStates{}

class AppGetUserPostsErrorState extends AppStates{}


//-----------------------------------------------



//GET USER SUBSCRIPTIONS

class AppGetUserSubscriptionsLoadingState extends AppStates{}

class AppGetUserSubscriptionsSuccessState extends AppStates{}

class AppGetUserSubscriptionsErrorState extends AppStates{}


//-----------------------------------------------


//GET USER SUBSCRIPTIONS

class AppGetUserSubscriptionsDetailsLoadingState extends AppStates{}

class AppGetUserSubscriptionsDetailsSuccessState extends AppStates{}

class AppGetUserSubscriptionsDetailsErrorState extends AppStates{}


//-----------------------------------------------

//MANAGE SUBSCRIPTIONS

class AppManageSubscriptionsLoadingState extends AppStates{}

class AppManageSubscriptionsSuccessState extends AppStates{}

class AppManageSubscriptionsErrorState extends AppStates{}


//-----------------------------------------------

//GET NEWS

class AppGetNewsLoadingState extends AppStates{}

class AppGetNewsSuccessState extends AppStates{}

class AppGetNewsErrorState extends AppStates{}

//-----------------------------------------------

// GET POSTS


class AppGetPostsLoadingState extends AppStates{}

class AppGetPostsSuccessState extends AppStates{}

class AppGetPostsErrorState extends AppStates{}


//-----------------------------------------------

// GET NEW POSTS


class AppGetNewPostsLoadingState extends AppStates{}

class AppGetNewPostsSuccessState extends AppStates{}

class AppGetNewPostsErrorState extends AppStates{}




//-----------------------------------------------



// GET SUBSCRIPTIONS POSTS


class AppGetSubscriptionsLoadingState extends AppStates{}

class AppGetSubscriptionsSuccessState extends AppStates{}

class AppGetSubscriptionsErrorState extends AppStates{}


//-----------------------------------------------

// UPLOAD A POST


class AppUploadPostLoadingState extends AppStates{}

class AppUploadPostSuccessState extends AppStates{}

class AppUploadPostErrorState extends AppStates{
  final String error;

  AppUploadPostErrorState(this.error);
}


//-----------------------------------------------

// GET INQUIRIES


class AppGetInquiriesLoadingState extends AppStates{}

class AppGetInquiriesSuccessState extends AppStates{}

class AppGetInquiriesErrorState extends AppStates{}


//-----------------------------------------------



// UPLOAD TEXT INQUIRY


class AppUploadTextInquiryLoadingState extends AppStates{}

class AppUploadTextInquirySuccessState extends AppStates{}

class AppUploadTextInquiryErrorState extends AppStates{}


//-----------------------------------------------


// UPLOAD AUDIO INQUIRY


class AppUploadAudioInquiryLoadingState extends AppStates{}

class AppUploadAudioInquirySuccessState extends AppStates{}

class AppUploadAudioInquiryErrorState extends AppStates{}


//-----------------------------------------------



// UPLOAD IMAGE INQUIRY


class AppUploadImageInquiryLoadingState extends AppStates{}

class AppUploadImageInquirySuccessState extends AppStates{}

class AppUploadImageInquiryErrorState extends AppStates{}


//-----------------------------------------------

// UPDATE USER PROFILE DATA


class AppUpdateUserProfileLoadingState extends AppStates{}

class AppUpdateUserProfileSuccessState extends AppStates {}

class AppUpdateUserProfileErrorState extends AppStates
{
  final String error;

  AppUpdateUserProfileErrorState(this.error);
}


//-----------------------------------------------



// DELETE AN INQUIRY


class AppDeleteInquiryLoadingState extends AppStates{}

class AppDeleteInquirySuccessState extends AppStates{}

class AppDeleteInquiryErrorState extends AppStates
{
  final String error;

  AppDeleteInquiryErrorState(this.error);
}


//-----------------------------------------------


// DELETE POSTS


class AppDeleteAPostLoadingState extends AppStates{}

class AppDeleteAPostSuccessState extends AppStates{}

class AppDeleteAPostErrorState extends AppStates
{
  final String error;

  AppDeleteAPostErrorState(this.error);
}


//-----------------------------------------------


// CHECK NEW POSTS


class AppCheckNewPostsLoadingState extends AppStates{}

class AppCheckNewPostsSuccessState extends AppStates{}

class AppCheckNewPostsErrorState extends AppStates {}



//-----------------------------------------------


// GET A USER POSTS


class AppGetAUserPostsLoadingState extends AppStates{}

class AppGetAUserPostsSuccessState extends AppStates{}

class AppGetAUserPostsErrorState extends AppStates {}


//-----------------------------------------------


// LOGOUT

class AppLogoutLoadingState extends AppStates{}
class AppLogoutSuccessState extends AppStates{}
class AppLogoutErrorState extends AppStates{}

//-----------------------------------------------

//DELETE USER ACCOUNT

class AppDeleteUserAccountLoadingState extends AppStates{}
class AppDeleteUserAccountErrorState extends AppStates{}
class AppDeleteUserAccountSuccessState extends AppStates{}

//-----------------------------------------------

// GET TEXT FILE


class AppGetFileLoadingState extends AppStates{}

class AppGetFileSuccessState extends AppStates{}

class AppGetFileErrorState extends AppStates{}

// REMOVE FILE

class AppRemoveFileState extends AppStates{}

//---------------------------------------------

// GET AUDIO FILE

class AppGetAudioFileLoadingState extends AppStates{}

class AppGetAudioFileSuccessState extends AppStates{}

class AppGetAudioFileErrorState extends AppStates{}

// REMOVE FILE
class AppRemoveAudioFileState extends AppStates{}



//-----------------------------------------------


// GET IMAGE FILE


class AppGetImageFileLoadingState extends AppStates{}

class AppGetImageFileSuccessState extends AppStates{}

class AppGetImageFileErrorState extends AppStates{}

// REMOVE FILE
class AppRemoveImageFileState extends AppStates{}


//-----------------------------------------------


// SEND MESSAGES


class AppSendMessageLoadingState extends AppStates{}

class AppSendMessageSuccessState extends AppStates{}

class AppSendMessageErrorState extends AppStates{}



// ADD YOUR MESSAGE


class AppAddMessageLoadingState extends AppStates{}

class AppAddMessageSuccessState extends AppStates{}

class AppAddMessageErrorState extends AppStates{}


// DELETE PREVIOUS MESSAGES

class AppRemoveMessagesLoadingState extends AppStates{}

class AppRemoveMessagesSuccessState extends AppStates{}

//-----------------------------------------------



// WEB SOCKETS

// ADD LIKE STATE

//For PostModel Posts

class AppWSAddLikePostModelLoadingState extends AppStates{}
class AppWSAddLikePostModelSuccessState extends AppStates
{
  final Post post;

  AppWSAddLikePostModelSuccessState(this.post);
}
class AppWSAddLikePostModelErrorState extends AppStates{}

//For Subscriptions posts

class AppWSAddLikeSubscriptionsPostsModelLoadingState extends AppStates{}
class AppWSAddLikeSubscriptionsPostsModelSuccessState extends AppStates{}
class AppWSAddLikeSubscriptionsPostsModelErrorState extends AppStates{}


//For a User Post Models

class AppWSAddLikeAUserPostsModelLoadingState extends AppStates{}
class AppWSAddLikeAUserPostsModelSuccessState extends AppStates{}
class AppWSAddLikeAUserPostsModelErrorState extends AppStates{}

//-----------------------------------------------

// DELETE COMMENT STATE

//For PostModel Posts
class AppWSModifyCommentPostModelLoadingState extends AppStates{}
class AppWSModifyCommentPostModelSuccessState extends AppStates
{
  final Post post;

  AppWSModifyCommentPostModelSuccessState(this.post);
}
class AppWSModifyCommentPostModelErrorState extends AppStates{}


//For Subscriptions posts
class AppWSModifyCommentSubscriptionsPostsModelLoadingState extends AppStates{}
class AppWSModifyCommentSubscriptionsPostsModelSuccessState extends AppStates{}
class AppWSModifyCommentSubscriptionsPostsModelErrorState extends AppStates{}


//For a User Post Models

class AppWSModifyCommentAUserPostsModelLoadingState extends AppStates{}
class AppWSModifyCommentAUserPostsModelSuccessState extends AppStates{}
class AppWSModifyCommentAUserPostsModelErrorState extends AppStates{}


//-----------------------------------------------

// DELETE POST STATE


//For PostModel Posts
class AppWSDeletePostPostModelLoadingState extends AppStates{}
class AppWSDeletePostPostModelSuccessState extends AppStates
{
  final Post post;

  AppWSDeletePostPostModelSuccessState(this.post);
}
class AppWSDeletePostPostModelErrorState extends AppStates{}


//For Subscriptions posts
class AppWSDeletePostSubscriptionsPostsModelLoadingState extends AppStates{}
class AppWSDeletePostSubscriptionsPostsModelSuccessState extends AppStates{}
class AppWSDeletePostSubscriptionsPostsModelErrorState extends AppStates{}

//For a User Post Models

class AppWSDeletePostAUserPostsModelLoadingState extends AppStates{}
class AppWSDeletePostAUserPostsModelSuccessState extends AppStates{}
class AppWSDeletePostAUserPostsModelErrorState extends AppStates{}

//-----------------------------------------------
