import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:deepfake_detection/models/PostModel/PostModel.dart';
import 'package:deepfake_detection/modules/AUserProfile/AUserProfile.dart';
import 'package:deepfake_detection/modules/PostDetails/postDetails.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Localization/Localization.dart';
import 'constants.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboard,
  required String label,
  required IconData prefix,
  required String? Function(String?)? validate,
  IconData? suffix,
  bool isObscure = false,
  bool isClickable = true,
  void Function(String)? onSubmit,
  void Function()? onPressedSuffixIcon,
  void Function()? onTap,
  void Function(String)? onChanged,
  void Function(String?)? onSaved,
  InputBorder? focusedBorderStyle,
  InputBorder? borderStyle,
  TextStyle? labelStyle,
  Color? prefixIconColor,
  Color? suffixIconColor,
  TextInputAction? inputAction,
  double borderRadius=8,
  double contentPadding=25,
  bool readOnly=false,
  int? digitsLimits,

  bool isFilled=false,
  Color? fillColor,
}) =>
    TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboard,
      onFieldSubmitted: onSubmit,
      textInputAction: inputAction,
      validator: validate,
      enabled: isClickable,
      readOnly: readOnly,
      onTap: onTap,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: isFilled,
        fillColor: fillColor,
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: focusedBorderStyle,
        enabledBorder: borderStyle,
        labelStyle: labelStyle,
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: contentPadding),
        prefixIcon: Icon(prefix, color: prefixIconColor,),
        suffixIcon: IconButton(
          onPressed: onPressedSuffixIcon,
          icon: Icon(
            suffix,
            color: suffixIconColor,
          ),
        ),
      ),
      inputFormatters:
      [
        LengthLimitingTextInputFormatter(digitsLimits),
      ],
    );


//--------------------------------------------------------------------------------------------------\\



//Default Boxes


Widget defaultBox(
{
  required AppCubit cubit,
  required boxColor,
  double borderRadius=8,
  double padding=25,
  bool paddingOptions=true,
  required Widget child,
  required void Function()? onTap,

  bool manualBorderColor=false,
  Color borderColor=Colors.white,

  double? containerWidth,

})=>GestureDetector(

  onTap: onTap,
  child:  Container(

    padding: paddingOptions? EdgeInsetsDirectional.only(start: padding/1.5, end:padding, bottom:padding*1.2, top:padding/1.5) : EdgeInsetsDirectional.only(start: padding, end:padding, bottom:padding, top:padding) ,

    decoration: BoxDecoration(

      color: boxColor,

      borderRadius: BorderRadius.circular(borderRadius),

      border: Border.all(
          color: manualBorderColor ? borderColor : cubit.isDarkTheme? Colors.white : Colors.black
      ),

    ),

    width: containerWidth,

    child: child,


  ),
);


//------------------------------------------------------------------------------------------------------\\



Widget defaultAddPostBox(
    {
      required AppCubit cubit,
      required boxColor,
      double borderRadius=8,
      double padding=25,
      bool paddingOptions=true,
      required Widget child,
      required void Function()? onTap,
      required BuildContext context,
      bool manualBorderColor=false,
      Color borderColor=Colors.white,

    })=>GestureDetector(
  onTap: onTap,
  child:  Container(

    padding: EdgeInsetsDirectional.only(start: padding, end:padding, bottom:padding, top:0),

    decoration: BoxDecoration(

      color: boxColor,

      borderRadius: BorderRadius.circular(borderRadius),

      border: Border.all(
          color: manualBorderColor ? borderColor : cubit.isDarkTheme? Colors.white : Colors.black
      ),

    ),

    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height/2.5 , minWidth: double.infinity),

    child: child,

  ),
);


//------------------------------------------------------------------------------------------------------\\


Widget defaultQueryBox(
    {
      required boxColor,
      double borderRadius=8,
      double padding=15,
      required Widget child,
      required void Function()? onTap,

    })=>GestureDetector(
      onTap: onTap,
      child: Container(
  padding: EdgeInsetsDirectional.all(padding),
  decoration: BoxDecoration(
      color: boxColor,
      borderRadius: BorderRadius.circular(borderRadius),),
  child: child,
),
    );



//------------------------------------------------------------------------------------------------------\\

Widget defaultButton(
{
  double letterSpacing=0,
  String title='Submit',
  AlignmentGeometry childAlignment=Alignment.center,
  double borderRadius=6,
  AlignmentGeometry gradientEndArea= Alignment.topRight,
  AlignmentGeometry gradientStartArea= Alignment.topLeft,
  required Color color,
  Color textColor=Colors.black,
  required void Function()? onTap,
  double width=185,

})
{
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: childAlignment,
      width: width,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
          fontFamily: 'WithoutSans',
          letterSpacing: letterSpacing,
        ),
      ),
    ),
  );
}


//-------------------------------------------------------------------------------------------------------\\


//DefaultToast message


Future<bool?> defaultToast({
  required String msg,
  ToastStates state=ToastStates.defaultType,
  ToastGravity position = ToastGravity.BOTTOM,
  Color color = Colors.grey,
  Color textColor= Colors.white,
  Toast length = Toast.LENGTH_SHORT,
  int time = 1,
}) =>
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: time,
      toastLength: length,
      backgroundColor: chooseToastColor(state),
      textColor: textColor,
    );

enum ToastStates{success,error,warning, defaultType}

Color chooseToastColor(ToastStates state) {
  switch (state)
  {
    case ToastStates.success:
      return Colors.green;
  // break;

    case ToastStates.error:
      return Colors.red;
  // break;

    case ToastStates.defaultType:
      return Colors.grey;

    case ToastStates.warning:
      return Colors.amber;
  // break;


  }
}

//--------------------------------------------------------------------------------------------------\\


// Navigate to a screen, it takes context and a widget to go to.

void navigateTo( BuildContext context, Widget widget) =>Navigator.push(
  context,
  MaterialPageRoute(builder: (context)=>widget),

);

//--------------------------------------------------------------------------------------------------\\



// Navigate to a screen and save the route name

void navigateAndSaveRouteSettings( BuildContext context, Widget widget, String routeName) =>Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context)=>widget,
    settings: RouteSettings(name: routeName,),
  ),

);

//--------------------------------------------------------------------------------------------------\\


// Navigate to a screen and destroy the ability to go back
void navigateAndFinish(context,Widget widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context)=>widget),
      (route) => false,  // The Route that you came from, false will destroy the path back..
);


//--------------------------------------------------------------------------------------------------\\

//Default Divider for ListViews ...
Widget myDivider({Color? color=Colors.grey, double padding=0}) => Container(height: 1, width: double.infinity , color:color, padding: EdgeInsets.symmetric(horizontal: padding),);


//------------------------------------------------------------------------\\



//Convert a Color to MaterialColor

MaterialColor getMaterialColor(Color color) {
  final Map<int, Color> shades = {
    50:  const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromRGBO(136, 14, 79, .2),
    200: const Color.fromRGBO(136, 14, 79, .3),
    300: const Color.fromRGBO(136, 14, 79, .4),
    400: const Color.fromRGBO(136, 14, 79, .5),
    500: const Color.fromRGBO(136, 14, 79, .6),
    600: const Color.fromRGBO(136, 14, 79, .7),
    700: const Color.fromRGBO(136, 14, 79, .8),
    800: const Color.fromRGBO(136, 14, 79, .9),
    900: const Color.fromRGBO(136, 14, 79, 1),
  };
  return MaterialColor(color.value, shades);
}




//---------------------------------------------------------------------------------\\



//---------------------------------------------------------------------------------\\


Widget defaultLinearProgressIndicator(BuildContext context, {double? value})
{
  return LinearProgressIndicator(
    backgroundColor: AppCubit.get(context).isDarkTheme? defaultSecondaryDarkColor : defaultThirdColor,
    value: value,
  );
}


Widget defaultProgressIndicator(BuildContext context, {double? value})
{
  return CircularProgressIndicator(
    backgroundColor: AppCubit.get(context).isDarkTheme? defaultSecondaryDarkColor : defaultThirdColor,
    value: value,
  );
}


//---------------------------------------------------------------------------------------\\


isNumeric(string) => num.tryParse(string) != null;


//------------------------------------------------------------------------------------------\\


Widget defaultAlertDialog(
    {
      required BuildContext context,
      required String title,
      required Widget content,
    })
{
  return AlertDialog(
    title: Text(
      title,
      textAlign: TextAlign.center,
    ),

    content: content,

    elevation: 50,

    contentTextStyle: TextStyle(
      fontSize: 16,
      color:  AppCubit.get(context).isDarkTheme? Colors.white: Colors.black,
      fontFamily: 'WithoutSans',
      fontWeight: FontWeight.w400
    ),

    titleTextStyle: TextStyle(
      fontSize: 22,
      color:  AppCubit.get(context).isDarkTheme? Colors.white: Colors.black,
      fontWeight: FontWeight.w500,
      fontFamily: 'Neology',
    ),

    backgroundColor: AppCubit.get(context).isDarkTheme? defaultAlertDarkColor: defaultHomeColor,

    shape: Dialogs.dialogShape,
  );
}


//------------------------------------------------------------------------------------------\\

PreferredSizeWidget defaultAppBar({
  required AppCubit cubit,
  List<Widget>? actions,
})=>AppBar(

  title: Text(
    Localization.translate('appBar_title_home'),
    style: TextStyle(
      color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
      fontFamily: 'Neology',
    ),
  ),

  actions:actions,


);



//------------------------------------------------------------------------------------------\\

//Post Item Builder

Widget postItemBuilder({required AppCubit cubit, required Post post, required BuildContext context, bool isCommentClickable =true, bool isBoxClickable=true, bool isPhotoClickable=true})=>defaultBox(
    cubit: cubit,
    boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
    borderColor: post.inquiry!.result! == 'fake' ? defaultRedColor : Colors.white, //If Inquiry is fake => Border Color is RedAccent
    manualBorderColor: post.inquiry!.result! == 'fake' ? true : false,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children:
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            //Used Constrained Box so even if the name is too long, it won't push the text title with it.
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/8),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.vertical,
                spacing: 1,
                children:
                [
                  GestureDetector(
                    onTap: ()
                    {
                      if(isPhotoClickable)
                      {
                        cubit.getAUserPosts(post.owner!.id!);
                        navigateTo(context, AUserProfile(user: post.owner!));
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile/${post.owner!.photo!}'),
                      radius: 22,
                    ),
                  ),

                  const SizedBox(height: 8,),

                  Text(
                    post.owner!.name!.length >10 ? '${ post.owner!.name!.substring(0,10).capitalize!}...' :  post.owner!.name!.capitalize!  ,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5,),

            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 8.0, start: 8.0),
                child: Text(
                  post.title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),


          ],
        ),

        const SizedBox(height: 15,),

        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Wrap(
                alignment:WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children:
                [
                  IconButton(
                      onPressed: ()
                      {
                        cubit.addLike(userID: AppCubit.userData!.id!, postID: post.id!);
                      },
                      icon: Icon(
                        isLiked(post)? Icons.thumb_up :Icons.thumb_up_off_alt_outlined,
                        color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                      )
                  ),

                  Text(
                  calculateNumberOfLikes(post.likes!),
                  ),
                ],
              ),

              Wrap(
                alignment:WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children:
                [
                  IconButton(
                      onPressed: ()
                      {
                        if(isCommentClickable)
                          {
                            navigateTo(context, PostDetails(globalPost: post));
                          }
                      },
                      icon: Icon(
                        Icons.comment_rounded,
                        color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                      )
                  ),

                  Text(
                    calculateNumberOfComments(post.comments!),
                  ),
                ],
              ),

              //const Spacer(),

              const SizedBox(width: 50,),

              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: defaultQueryBox(
                      boxColor: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor,
                      child: Text(
                        post.inquiry!.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap:() async
                      {
                        File? file=await base64ToFile(
                            base: post.inquiry!.data!,
                            type: post.inquiry!.type!,
                            id: post.inquiry!.id!,
                        );

                        if(file!=null)
                        {
                          print('Converted File');
                          openFile(file.path);
                        }
                      }
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15,),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(Localization.translate('post_date')),

            const SizedBox(width: 5,),

            Text(
              dateFormatter(post.createdAt!),
            ),
          ],
        ),
      ],
    ),

    onTap: ()
    {
      if(isBoxClickable)
        {
          navigateTo(context, PostDetails(globalPost: post,) );
        }
    }
);


//------------------------------------------------------------------------------------------\\

//Comment Item Builder


Widget commentItemBuilder({required AppCubit cubit, required Comment comment, required BuildContext context})=>Column(
  crossAxisAlignment: CrossAxisAlignment.start,

  children:
  [
    Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Column(
              children:
              [

                 GestureDetector(
                   onTap: ()
                   {
                     print(comment.owner!.lastName!);
                     if(comment.owner !=null)
                       {
                         cubit.getAUserPosts(comment.owner!.id!);
                         navigateTo(context, AUserProfile(user: comment.owner!));
                       }

                   },
                   child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile/${comment.owner!.photo!}'),
                    radius: 22,
                ),
                 ),

                const SizedBox(height: 8,),

                Text(
                  comment.owner!.name!.length >10 ? '${comment.owner!.name!.substring(0,10)}...' : comment.owner!.name!  ,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),

              ],
            ),

            const SizedBox(width: 10,),

            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 8.0, start: 8.0),
                child: Text(
                  comment.comment!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(Localization.translate('comment_date')),

            const SizedBox(width: 5,),

            Text(
              comment.createdAt !=null ? dateFormatter(comment.createdAt!) : '',
            ),
          ],
        ),
      ],
    ),
  ],
);


//------------------------------------------------------------------------------------------\\

//URL Launcher

Future<void> defaultLaunchUrl(String ur) async
{
  final Uri url = Uri.parse(ur);
  if (!await launchUrl(url))
  {
    throw 'Could not launch $url';
  }
}

//------------------------------------------------------------------------------------------\\

// Calculate the number of comments/likes and return it as String, 1000 => 1K ,  200,000 => 200K etc...

String calculateNumberOfLikes(List<Like> likes)
{
  return '${likes.length}';
}


String calculateNumberOfComments(List<Comment> comments)
{
  return '${comments.length}';
}


//------------------------------------------------------------------------------------------\\

//Format Date to More readable one
String dateFormatter(String date)
{
  DateTime dateTime=DateTime.parse(date);

  DateFormat format= DateFormat('dd-MM-yyyy HH.mm');

  return format.format(dateTime);
}


//------------------------------------------------------------------------------------------\\

//Open Local Files From Path

Future<void> openFile(String path)
async {
  OpenFile.open(path).then((value)
  {
    print(value);
    if(value.message.contains('No APP found to open this file'))
      {
        defaultToast(msg: value.message, length: Toast.LENGTH_LONG);
      }
  }).catchError((error)
  {
    print('ERROR WHILE OPENING FILE, ${error.toString()}');
    defaultToast(msg: error.toString());
  });
}

//------------------------------------------------------------------------------------------\\

//Generate Random String

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));

//------------------------------------------------------------------------------------------\\

//Convert the Base64 Back to File

Future<File?> base64ToFile({required String base, required String type, required String id})async
{
  if(await File('$appDocPath/$id.$type').exists() == false)
    {
      Uint8List decodedBytes= base64.decode(base);

      //File file= await File('$appDocPath/${getRandomString(10)}.$type').writeAsBytes(decodedBytes);

      File file= await File('$appDocPath/$id.$type').writeAsBytes(decodedBytes);
      return file;

    }

  else
    {
      print('File Exists already');

      File file= File('$appDocPath/$id.$type');
      return file;
    }

}

//------------------------------------------------------------------------------------------\\


//Write a String Data into a File and return it

Future<File> writeFileFromText(String data, String title) async
{
  // final File file= File('$appDocPath/${getRandomString(5)}.txt');

  final File file= File('$appDocPath/$title.txt');

  await file.writeAsString(data);

  return file;
}

//------------------------------------------------------------------------------------------\\

//Returns True/False for if a User is subscribed to another or not

bool isSubscribed({required String userId, required AppCubit cubit})
{
  for (var element in cubit.subscriptionsModel!.subscriptions!)
  {
    if(element.ownerId! == userId)
      {
        return true;
      }
  }
  return false;
}


//------------------------------------------------------------------------------------------\\

//Check if a Post is already Liked or Not
bool isLiked(Post post)
{
  for (var like in post.likes!)
  {
    if(like.owner! == AppCubit.userData!.id!)
      {
        return true;

      }
  }
  return false;
}


//------------------------------

//Convert Bytes into MB...
int byteToMB(int byte)
{
  return (byte * 0.000001).round();
}

//---------------------------------

Future<void>firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  print('Got background message');
  print(message.data.toString());

  defaultToast(msg: 'DeepGuard Data');
}