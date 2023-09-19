abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeBottomNavBar extends AppStates{}

class AppChangeThemeModeState extends AppStates{}

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

// GET INQUIRIES


class AppGetInquiriesLoadingState extends AppStates{}

class AppGetInquiriesSuccessState extends AppStates{}

class AppGetInquiriesErrorState extends AppStates{}


//-----------------------------------------------

// UPDATE USER PROFILE DATA


class AppUpdateUserProfileLoadingState extends AppStates{}

class AppUpdateUserProfileSuccessState extends AppStates{}

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


// GET POSTS


class AppDeleteAPostLoadingState extends AppStates{}

class AppDeleteAPostSuccessState extends AppStates{}

class AppDeleteAPostErrorState extends AppStates
{
  final String error;

  AppDeleteAPostErrorState(this.error);
}


//-----------------------------------------------

// LOGOUT

class AppLogoutState extends AppStates{}

