import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/home_layout.dart';
import 'package:deepfake_detection/modules/Register/cubit/registerCubit.dart';
import 'package:deepfake_detection/modules/Register/cubit/registerStates.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/components/constants.dart';
import 'package:deepfake_detection/shared/network/local/cache_helper.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as int;

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController=TextEditingController();

  TextEditingController passwordController=TextEditingController();

  TextEditingController nameController=TextEditingController();

  TextEditingController birthDateController=TextEditingController();

  var formKey=GlobalKey<FormState>();

  List<String> listOfGenders = ['Male','Female'];

  String currentGender='Male';
  //User's Gender.
  @override
  Widget build(BuildContext context) {
    return BlocProvider( create: (context)=>RegisterCubit(),

      child: BlocConsumer<RegisterCubit,RegisterStates>(

        listener: (context,state)
        {
          if(state is RegisterErrorState)
          {
            defaultToast(msg: state.error, state: ToastStates.error);
          }

          if(state is RegisterSuccessState)
          {
            if(state.registerModel.success ==0)
            {
              defaultToast(msg: "Couldn't Sign you in", state: ToastStates.error);
            }

            if(state.registerModel.user !=null)
            {
              defaultToast(msg: 'Success', state: ToastStates.success);

              CacheHelper.saveData(key: 'token', value: state.registerModel.token).then((value)
              {
                token=state.registerModel.token!;

                AppCubit.get(context).getUserData();

                AppCubit.get(context).getPosts();

                AppCubit.get(context).getInquiries();

                navigateAndFinish(context, const HomeLayout());

              }).catchError((error)
              {
                print('ERROR WHILE CACHING USER TOKEN IN REGISTER, ${error.toString()}');
              });
            }


          }
        },

        builder: (context,state)
        {
          var cubit=RegisterCubit.get(context);

          return Scaffold(
            appBar: AppBar(),

            body: Directionality(
              textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
              child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          Text(
                            Localization.translate('register_title'),
                            style: TextStyle(
                              color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                              fontFamily: 'Neology',
                              fontSize: 42,
                            ),

                          ),

                          const SizedBox(height: 40,),

                          Text(
                            Localization.translate('register_second_title'),
                            style: TextStyle(
                              fontSize: 16,
                              color: AppCubit.get(context).isDarkTheme? defaultDarkFontColor : defaultFontColor,
                              fontFamily: 'WithoutSans',
                            ),
                          ),

                          const SizedBox(height: 60,),



                          defaultFormField(
                              controller: nameController,
                              keyboard: TextInputType.name,
                              label: Localization.translate('name_reg_tfm'),
                              prefix: Icons.person_rounded,
                              isFilled: true,
                              fillColor: AppCubit.get(context).isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                              validate: (value)
                              {
                                if(value!.isEmpty)
                                {
                                  return Localization.translate('name_reg_tfm_error');
                                }
                                return null;
                              }
                          ),

                          const SizedBox(height: 40,),



                          //Gender Drop Down List.
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    fillColor: AppCubit.get(context).isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                    filled: true,
                                    errorStyle:const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                    labelText: Localization.translate('gender_reg_tfm'),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),)),

                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    style: TextStyle(color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor),
                                    value: currentGender,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        currentGender = newValue!;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: listOfGenders.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),


                                  ),
                                ),
                              );
                            },
                          ),


                          const SizedBox(height: 40,),


                          //Birth Date
                          defaultFormField(
                              isFilled: true,
                              fillColor: AppCubit.get(context).isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                              controller: birthDateController,
                              keyboard: TextInputType.datetime,
                              label: Localization.translate('birth_reg_tfm'),
                              prefix: Icons.date_range,
                              readOnly: true, //User Cannot Type in it.
                              onTap: ()
                              {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1920),
                                  lastDate: DateTime.now(),

                                ).then((value)
                                {
                                  birthDateController.text = int.DateFormat("dd-MM-yyy").format(value!);  //2011-08-05 DateFormat.yMd().format(value!)
                                }).catchError((e){
                                  print('Caught error with value, ${e.toString()}');
                                });
                              },
                              validate: (String? value)
                              {
                                if(value!.isEmpty)
                                {
                                  return Localization.translate('birth_reg_tfm_error');
                                }
                                return null;
                              },
                          ),

                          const SizedBox(height: 40,),

                          defaultFormField(
                              controller: emailController,
                              keyboard: TextInputType.emailAddress,
                              label: Localization.translate('email_reg_tfm'),
                              prefix: Icons.email_outlined,
                              isFilled: true,
                              fillColor: AppCubit.get(context).isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                              validate: (value)
                              {
                                if(value!.isEmpty)
                                {
                                  return Localization.translate('email_reg_tfm_error');
                                }
                                return null;
                              }
                          ),

                          const SizedBox(height: 40,),


                          defaultFormField(
                              controller: passwordController,
                              keyboard: TextInputType.text,
                              label: Localization.translate('password_reg_tfm'),
                              prefix: Icons.password_rounded,
                              suffix: cubit.isPassVisible? Icons.visibility_off_rounded : Icons.visibility_rounded,
                              isFilled: true,
                              fillColor: AppCubit.get(context).isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                              validate: (value)
                              {
                                if(value!.isEmpty)
                                {
                                  return Localization.translate('password_reg_tfm_error');
                                }
                                return null;
                              },

                              isObscure: cubit.isPassVisible,
                              onPressedSuffixIcon: ()
                              {
                                cubit.changePassVisibility();
                              }
                          ),


                          const SizedBox(height: 40,),


                          ConditionalBuilder(
                            condition: state is RegisterLoadingState,
                            builder: (context)=> Center(child: defaultProgressIndicator(context)),
                            fallback: (context)=> Center(
                              child: defaultButton(
                                color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                                textColor: AppCubit.get(context).isDarkTheme? Colors.black : Colors.white,
                                title: Localization.translate('submit_button'),
                                letterSpacing:2,
                                onTap: ()
                                {
                                  if(formKey.currentState!.validate())
                                  {
                                    cubit.registerUser(
                                      name: nameController.text,
                                      birthDate: birthDateController.text,
                                      gender: currentGender,
                                      email:emailController.text,
                                      password:passwordController.text,
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
              ),
            ),
          );
        },
        )
    );
  }
}
