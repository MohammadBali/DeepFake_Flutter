const String localhost= 'http://192.168.1.13:3000/'; //'http://192.168.188.87:3000';


//USER ENDPOINTS

const login='users/login';

const register='addUser';

const getUserDataByToken='users/me';

const getaProfileById='users/getAUserProfile'; // pass his ID

const deleteUser='users/delete';


//INQUIRIES ENDPOINTS

const addTextInquiry='addTextInquiry';

const getUserInquiries='inquiries/me';

const deleteUserInquiry= 'inquiries/delete';


//POSTS ENDPOINTS

const addPost='addPost';

const addLike='AddLike';

const posts='posts';

const getUserPosts='posts/me';

const getUserLikedPosts='likedPosts';

const deleteAPost='deletePost'; // pass Post's ID


//NEWS ENDPOINTS

const news='getNews';


