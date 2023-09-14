import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:material_dialogs/dialogs.dart';

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
  required boxColor,
  double borderRadius=8,
  double padding=25,
  required Widget child,

})=>Container(
  padding: EdgeInsetsDirectional.only(start: padding/1.5, end:padding, bottom:padding*1.2, top:padding/1.5),
  decoration: BoxDecoration(
    color: boxColor,
    borderRadius: BorderRadius.circular(borderRadius),),
  child: child,
);


//------------------------------------------------------------------------------------------------------\\



Widget defaultQueryBox(
    {
      required boxColor,
      double borderRadius=8,
      double padding=15,
      required Widget child,

    })=>Container(
  padding: EdgeInsetsDirectional.all(padding),
  decoration: BoxDecoration(
    color: boxColor,
    borderRadius: BorderRadius.circular(borderRadius),),
  child: child,
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

})
{
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: childAlignment,
      width: 185,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
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


Widget defaultLinearProgressIndicator(BuildContext context)
{
  return LinearProgressIndicator(
    backgroundColor: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
  );
}


Widget defaultProgressIndicator(BuildContext context)
{
  return CircularProgressIndicator(
    backgroundColor: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,

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
      fontSize: 18,
      color:  AppCubit.get(context).isDarkTheme? Colors.white: Colors.black,
      fontFamily: 'WithoutSans',
    ),

    titleTextStyle: TextStyle(
      fontSize: 24,
      color:  AppCubit.get(context).isDarkTheme? Colors.white: Colors.black,
      fontWeight: FontWeight.w600,
      fontFamily: 'WithoutSans',
    ),

    backgroundColor: AppCubit.get(context).isDarkTheme? defaultAlertDarkColor: defaultHomeColor,

    shape: Dialogs.dialogShape,
  );
}


//------------------------------------------------------------------------------------------\\

PreferredSizeWidget defaultAppBar({
  required AppCubit cubit,
})=>AppBar(

  title: Text(
    'Deep Guard',
    style: TextStyle(
      color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
      fontFamily: 'Neology',
    ),
  ),

  actions:[
    IconButton(
      onPressed: (){},
      icon: const Icon(Icons.person_4),
    ),
  ],


);