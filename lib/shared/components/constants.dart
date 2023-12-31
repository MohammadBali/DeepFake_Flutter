//User Token
String token='';

//Directory To Store Files
String appDocPath='';


//Maximum Size in Bytes for TextFiles
int maxTextFileSize= 12000000; //12MB

//Maximum Size in Bytes for AudioFiles
int maxAudioFileSize= 50000000; //50MB

//Maximum Size in Bytes for ImageFiles
int maxImageFileSize=10000000; //10MB

//Firebase Token

String? firebaseToken='';

//Is Active in app => allows re connection to WebSockets

bool isActive=true;


//Allowed Files to be uploaded
List<String> allowedImageTypes=['jpg','jpeg','png'];
List<String> allowedAudioTypes=['mp3','rm','wav'];
List<String> allowedTextTypes=['docx','doc','txt','pdf'];