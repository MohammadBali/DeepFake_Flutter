import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/layout/home_layout.dart';
import 'package:deepfake_detection/modules/Login/cubit/loginCubit.dart';
import 'package:deepfake_detection/modules/Login/cubit/loginStates.dart';
import 'package:deepfake_detection/modules/Register/register.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';

import 'package:deepfake_detection/shared/components/constants.dart';
import 'package:deepfake_detection/shared/network/local/cache_helper.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController=TextEditingController();

  TextEditingController passwordController=TextEditingController();

  var formKey=GlobalKey<FormState>();

  List<String> listOfLanguages = ['ar','en'];

  String currentLanguage= AppCubit.language??='en';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>LoginCubit(),

      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state)
        {
          if(state is LoginErrorState)
          {
            defaultToast(msg: state.error, state: ToastStates.error);
          }

          if(state is LoginSuccessState)
          {
            if(state.loginModel.success ==0)
              {
                defaultToast(msg: Localization.translate('login_error_toast'), state: ToastStates.error);
              }

            if(state.loginModel.user !=null)
            {
              defaultToast(msg: Localization.translate('login_successfully_toast'), state: ToastStates.success);

              CacheHelper.saveData(key: 'token', value: state.loginModel.token).then((value)
              {
                var cubit= AppCubit.get(context);
                token=state.loginModel.token!;

                cubit.getUserData();

                cubit.getPosts();

                cubit.getUserPosts();

                cubit.getInquiries();

                cubit.getUserPosts();

                cubit.getSubscriptions();

                cubit.getSubscriptionsPosts();

                navigateAndFinish(context,const HomeLayout());

              }).catchError((error)
              {
                print('ERROR WHILE CACHING USER TOKEN IN LOGIN, ${error.toString()}');
              });
            }


          }
        },

        builder: (context,state)
        {
          var cubit= LoginCubit.get(context);

          return BlocConsumer<AppCubit,AppStates>(
              listener: (appContext,appState){},
              builder:(appContext,appState)
              {
                var appCubit= AppCubit.get(appContext);

                return Directionality(
                  textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    appBar: AppBar(),
                    body: OrientationBuilder(
                        builder: (context,orientation)
                        {
                          if(orientation==Orientation.portrait)
                          {
                            return Form(
                              key: formKey,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(top:24.0, start: 24.0, end: 24.0, bottom: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children:
                                  [
                                    Text(
                                      Localization.translate('login_title'),
                                      style: TextStyle(
                                        color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                                        fontFamily: 'Neology',
                                        fontSize: 42,
                                      ),

                                    ),

                                    const SizedBox(height: 5,),

                                    Text(
                                      Localization.translate('login_second_title'),//'Login Now and Start Revealing the Truth',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppCubit.get(context).isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                        fontFamily: 'WithoutSans',
                                      ),
                                    ),

                                    const SizedBox(height: 60,),

                                    defaultFormField(
                                      controller: emailController,
                                      keyboard: TextInputType.emailAddress,
                                      label: Localization.translate('email_login_tfm'),
                                      prefix: Icons.email_outlined,
                                      isFilled: true,
                                      fillColor: appCubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                      validate: (value)
                                      {
                                        if(value!.isEmpty)
                                        {
                                          return Localization.translate('email_login_tfm_error');
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 25),


                                    defaultFormField(
                                        controller: passwordController,
                                        keyboard: TextInputType.text,
                                        label: Localization.translate('password_login_tfm'),
                                        prefix: Icons.password_rounded,
                                        //suffixIconColor: Colors.grey,
                                        suffix: cubit.isPassVisible? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                        isFilled: true,
                                        fillColor: appCubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                        validate: (value)
                                        {
                                          if(value!.isEmpty)
                                          {
                                            return Localization.translate('password_login_tfm_error');
                                          }
                                          return null;
                                        },

                                        isObscure: cubit.isPassVisible,

                                        onSubmit: (value)
                                        {
                                          if(formKey.currentState!.validate())
                                            {
                                              cubit.userLogin(
                                                  emailController.text,
                                                  passwordController.text
                                              );
                                            }
                                        },

                                        onPressedSuffixIcon: ()
                                        {
                                          cubit.changePassVisibility();
                                        },

                                    ),


                                    const SizedBox(height: 20,),


                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional.centerStart,
                                              child: FormField<String>(
                                                builder: (FormFieldState<String> state) {
                                                  return InputDecorator(
                                                    decoration: InputDecoration(
                                                      enabledBorder: InputBorder.none,
                                                      border: InputBorder.none,
                                                      focusedBorder: InputBorder.none,
                                                      errorStyle:const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                                      labelText: Localization.translate('language_name_general_settings'),
                                                    ),

                                                    child: DropdownButtonHideUnderline(
                                                      child: DropdownButton<String>(
                                                        style: TextStyle(color: appCubit.isDarkTheme? defaultDarkColor : defaultColor),
                                                        value: currentLanguage,
                                                        isDense: true,
                                                        onChanged: (newValue) {

                                                          setState(() {
                                                            print('Current Language is: $newValue');
                                                            currentLanguage = newValue!;
                                                            state.didChange(newValue);

                                                            CacheHelper.saveData(key: 'language', value: newValue).then((value){
                                                              appCubit.changeLanguage(newValue);
                                                              Localization.load(Locale(newValue));

                                                            }).catchError((error)
                                                            {
                                                              print('ERROR WHILE SWITCHING LANGUAGES, ${error.toString()}');
                                                              defaultToast(msg: error.toString());
                                                            });
                                                          });
                                                        },
                                                        items: listOfLanguages.map((String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    value == 'ar' ? 'Arabic' : 'English'
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional.centerEnd,
                                              child: TextButton(
                                                child: Text(
                                                  Localization.translate('registerNow'),
                                                  style: TextStyle(
                                                    color: appCubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                                    decoration: TextDecoration.underline,
                                                    fontFamily: 'Neology',
                                                  ),
                                                ),
                                                onPressed: ()
                                                {
                                                  navigateTo(context, Register());
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //const SizedBox(height: 40,),

                                    Expanded(
                                      child: ConditionalBuilder(
                                        condition: state is LoginLoadingState,
                                        builder: (context)=> Center(child: defaultProgressIndicator(context)),
                                        fallback: (context)=> Center(
                                          child: defaultButton(
                                            color: appCubit.isDarkTheme? defaultDarkColor : defaultColor,
                                            textColor: appCubit.isDarkTheme? Colors.black : Colors.white,
                                            title: Localization.translate('submit_button_login'),
                                            letterSpacing:2,
                                            onTap: ()
                                            {
                                              if(formKey.currentState!.validate())
                                              {
                                                cubit.userLogin(
                                                  emailController.text,
                                                  passwordController.text,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          else
                          {
                            return SingleChildScrollView(
                              child: Form(
                                key: formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:
                                    [
                                      Text(
                                        Localization.translate('login_title'),
                                        style: TextStyle(
                                          color: appCubit.isDarkTheme? defaultDarkColor : defaultColor,
                                          fontFamily: 'Neology',
                                          fontSize: 42,
                                        ),

                                      ),

                                      const SizedBox(height: 40,),

                                      Text(
                                        Localization.translate('login_second_title'),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: appCubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                          fontFamily: 'WithoutSans',
                                        ),
                                      ),

                                      const SizedBox(height: 60,),

                                      defaultFormField(
                                          controller: emailController,
                                          keyboard: TextInputType.emailAddress,
                                          label: Localization.translate('email_login_tfm'),
                                          prefix: Icons.email_outlined,
                                          isFilled: true,
                                          fillColor: appCubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                          validate: (value)
                                          {
                                            if(value!.isEmpty)
                                            {
                                              return Localization.translate('email_login_tfm_error');
                                            }
                                            return null;
                                          }
                                      ),

                                      const SizedBox(height: 40,),


                                      defaultFormField(
                                          controller: passwordController,
                                          keyboard: TextInputType.text,
                                          label: Localization.translate('password_login_tfm'),
                                          prefix: Icons.password_rounded,
                                          //suffixIconColor: Colors.grey,
                                          suffix: cubit.isPassVisible? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                          isFilled: true,
                                          fillColor: appCubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                          validate: (value)
                                          {
                                            if(value!.isEmpty)
                                            {
                                              return Localization.translate('password_login_tfm_error');
                                            }
                                            return null;
                                          },

                                          isObscure: cubit.isPassVisible,

                                          onSubmit: (value)
                                          {
                                            if(formKey.currentState!.validate())
                                              {
                                                cubit.userLogin(
                                                    emailController.text,
                                                    passwordController.text
                                                );
                                              }
                                          },

                                          onPressedSuffixIcon: ()
                                          {
                                            cubit.changePassVisibility();
                                          }
                                      ),


                                      const SizedBox(height: 40,),


                                      Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional.centerStart,
                                              child: FormField<String>(
                                                builder: (FormFieldState<String> state) {
                                                  return InputDecorator(
                                                    decoration: InputDecoration(
                                                      enabledBorder: InputBorder.none,
                                                      border: InputBorder.none,
                                                      focusedBorder: InputBorder.none,
                                                      errorStyle:const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                                      labelText: Localization.translate('language_name_general_settings'),
                                                    ),

                                                    child: DropdownButtonHideUnderline(
                                                      child: DropdownButton<String>(
                                                        style: TextStyle(color: appCubit.isDarkTheme? defaultDarkColor : defaultColor),
                                                        value: currentLanguage,
                                                        isDense: true,
                                                        onChanged: (newValue) {

                                                          setState(() {
                                                            print('Current Language is: $newValue');
                                                            currentLanguage = newValue!;
                                                            state.didChange(newValue);

                                                            CacheHelper.saveData(key: 'language', value: newValue).then((value){
                                                              appCubit.changeLanguage(newValue);
                                                              Localization.load(Locale(newValue));

                                                            }).catchError((error)
                                                            {
                                                              print('ERROR WHILE SWITCHING LANGUAGES, ${error.toString()}');
                                                              defaultToast(msg: error.toString());
                                                            });
                                                          });
                                                        },
                                                        items: listOfLanguages.map((String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    value == 'ar' ? 'Arabic' : 'English'
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional.centerEnd,
                                              child: TextButton(
                                                child: Text(
                                                  Localization.translate('registerNow'),
                                                  style: TextStyle(
                                                    color: appCubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                                    decoration: TextDecoration.underline,
                                                    fontFamily: 'Neology',
                                                  ),
                                                ),
                                                onPressed: ()
                                                {
                                                  navigateTo(context, Register());
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 40,),

                                      ConditionalBuilder(
                                        condition: state is LoginLoadingState,
                                        builder: (context)=> Center(child: defaultProgressIndicator(context)),
                                        fallback: (context)=> Center(
                                          child: defaultButton(
                                            color: appCubit.isDarkTheme? defaultDarkColor : defaultColor,
                                            textColor: appCubit.isDarkTheme? Colors.black : Colors.white,
                                            title: Localization.translate('submit_button'),
                                            letterSpacing:2,
                                            onTap: ()
                                            {
                                              if(formKey.currentState!.validate())
                                              {
                                                cubit.userLogin(
                                                  emailController.text,
                                                  passwordController.text,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }
}
