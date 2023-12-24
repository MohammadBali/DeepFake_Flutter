// const String localhost= 'https://conversely-inviting-gelding.ngrok-free.app/'; // 'http://10.0.0.2:3000/'

const String localhost= 'http://192.168.1.1:3000/';

// const String webSocketLocalHost= 'ws://conversely-inviting-gelding.ngrok-free.app/webSocket';  // ws://192.168.1.1:3000/webSocket

const String webSocketLocalHost= 'ws://192.168.1.1:3000/webSocket';  // ws://192.168.1.1:3000/webSocket

//USER ENDPOINTS

const login='users/login';

const register='addUser';

const getUserDataByToken='users/me';

const getaProfileById='users/getAUserProfile'; // pass his ID

const deleteUser='users/delete';

const updateUser= 'users/me';

const userPosts= 'posts/me';

const subscriptions='getSubscriptions';

const subscriptionsDetails='getSubscriptionsDetails';

const manageSubs='manageSubscription';

const logoutOneToken='users/logout';


//INQUIRIES ENDPOINTS

const addTextInquiry='addTextInquiry';

const addAudioInquiry='addAudioInquiry';

const addImageInquiry='addImageInquiry';

const getUserInquiries='inquiries/me';

const deleteUserInquiry= 'inquiries/delete';


//POSTS ENDPOINTS

const addPost='addPost';

const addLike='AddLike';

const posts='posts';

const getUserPosts='posts/me';

const getUserLikedPosts='likedPosts';

const deleteAPost='deletePost'; // pass Post's ID

const getSomeUserPosts ='users/getAUserProfile';


const subscriptionsPosts='getSubscriptionsPosts';


//NEWS ENDPOINTS

const news='getNews';


// CHAT BOT

const chatBot='';


