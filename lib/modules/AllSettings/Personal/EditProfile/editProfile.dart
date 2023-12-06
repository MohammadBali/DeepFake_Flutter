import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/AllSettings/Personal/EditProfile/ChangePersonalPhoto.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController emailController=TextEditingController();

  TextEditingController firstNameController=TextEditingController();

  TextEditingController lastNameController=TextEditingController();

  var formKey=GlobalKey<FormState>();

  @override
  void initState()
  {
    super.initState();
    if(AppCubit.userData!=null)
      {
        firstNameController.text=AppCubit.userData!.name!;
        lastNameController.text=AppCubit.userData!.lastName!;
        emailController.text=AppCubit.userData!.email!;
      }

  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {
          if(state is AppUpdateUserProfileLoadingState)
            {
              defaultToast(msg: Localization.translate('update_profile_loading_toast'));
            }

          if(state is AppUpdateUserProfileSuccessState)
          {
              defaultToast(msg: Localization.translate('update_profile_success_toast'));
          }

          if(state is AppUpdateUserProfileErrorState)
          {
            defaultToast(msg: state.error);
          }
        },
        builder: (context,state)
        {
          var cubit=AppCubit.get(context);

          return Directionality(
            textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  Localization.translate('appBar_title_edit_profile_page'),
                  style:TextStyle(
                      color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                      fontFamily: 'WithoutSans',
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),

              body: SingleChildScrollView(
                child: ConditionalBuilder(
                  condition: AppCubit.userData!=null,
                  fallback: (context)=>Center(child: defaultProgressIndicator(context),),
                  builder: (context)=>Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(top:24.0, bottom: 24.0, end: 24.0),
                      child: Column(
                        children:
                        [
                          Row(
                            children:
                            [
                              Expanded(
                                child: GestureDetector(
                                  onTap: ()
                                  {
                                    navigateTo(context, const ChangePersonalPhoto() );
                                  },
                                  child: Stack(
                                    fit: StackFit.passthrough,
                                    alignment: Alignment.bottomCenter,
                                    children:
                                    [
                                      CircleAvatar(
                                        backgroundImage: AssetImage('assets/images/profile/${AppCubit.userData!.photo!}'),
                                        radius: 75,
                                      ),

                                      const Icon(Icons.camera_alt_outlined),
                                    ],
                                  ),
                                ),
                              ),


                              Expanded(
                                child: Text(
                                  '${AppCubit.userData!.name!} ${AppCubit.userData!.lastName!}',
                                  style: const TextStyle(
                                    fontFamily: 'Neology',
                                    fontSize: 24,

                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25,),

                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                              [
                                myDivider(color: cubit.isDarkTheme? defaultDarkColor : defaultColor),

                                const SizedBox(height: 40,),

                                Text(
                                  Localization.translate('edit_your_details_profile_page'),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'WithoutSans',
                                      fontWeight: FontWeight.w600
                                  ),
                                ),

                                const SizedBox(height: 25,),

                                defaultFormField(
                                    controller: firstNameController,
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



                                const SizedBox(height: 25,),

                                defaultFormField(
                                    controller: lastNameController,
                                    keyboard: TextInputType.name,
                                    label: Localization.translate('lastName_reg_tfm'),
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


                                const SizedBox(height: 25,),

                                defaultFormField(
                                    controller: emailController,
                                    keyboard: TextInputType.emailAddress,
                                    label: Localization.translate('email_reg_tfm'),
                                    prefix: Icons.email_rounded,
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

                                const SizedBox(height: 50,),

                                Center(
                                  child: defaultButton(
                                      color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                      title: Localization.translate('update_button_profile_page'),
                                      textColor: cubit.isDarkTheme? Colors.black: Colors.white,
                                      onTap: ()
                                      {
                                        cubit.updateUserProfile(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          email: emailController.text,
                                          photo: null,
                                        );
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
