import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/modules/AllSettings/Personal/EditProfile/ChangePersonalPhoto.dart';
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

  TextEditingController nameController=TextEditingController();

  var formKey=GlobalKey<FormState>();

  @override
  void initState()
  {
    super.initState();
    if(AppCubit.userData!=null)
      {
        nameController.text=AppCubit.userData!.name!;
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
              defaultToast(msg: 'Updating...');
            }

          if(state is AppUpdateUserProfileSuccessState)
          {
            defaultToast(msg: 'Successfully Updated');
          }

          if(state is AppUpdateUserProfileErrorState)
          {
            defaultToast(msg: state.error);
          }
        },
        builder: (context,state)
        {
          var cubit=AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Edit Profile',
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
                                      backgroundImage: AssetImage('assets/images/${AppCubit.userData!.photo!}'),
                                      radius: 75,
                                    ),

                                    const Icon(Icons.camera_alt_outlined),
                                  ],
                                ),
                              ),
                            ),


                            Expanded(
                              child: Text(
                                AppCubit.userData!.name!,
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

                              const Text(
                                'Edit Your Details',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'WithoutSans',
                                    fontWeight: FontWeight.w600
                                ),
                              ),

                              const SizedBox(height: 25,),

                              defaultFormField(
                                  controller: nameController,
                                  keyboard: TextInputType.name,
                                  label: 'Name',
                                  prefix: Icons.person_rounded,
                                  isFilled: true,
                                  fillColor: AppCubit.get(context).isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  validate: (value)
                                  {
                                    if(value!.isEmpty)
                                    {
                                      return 'Name is empty';
                                    }
                                    return null;
                                  }
                              ),


                              const SizedBox(height: 25,),

                              defaultFormField(
                                  controller: emailController,
                                  keyboard: TextInputType.emailAddress,
                                  label: 'Email Address',
                                  prefix: Icons.email_rounded,
                                  isFilled: true,
                                  fillColor: AppCubit.get(context).isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  validate: (value)
                                  {
                                    if(value!.isEmpty)
                                    {
                                      return 'Email is empty';
                                    }
                                    return null;
                                  }
                              ),

                              const SizedBox(height: 50,),

                              Center(
                                child: defaultButton(
                                    color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                    title: 'UPDATE',
                                    textColor: cubit.isDarkTheme? Colors.black: Colors.white,
                                    onTap: ()
                                    {
                                      cubit.updateUserProfile(
                                        name: nameController.text,
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
          );
        }
    );
  }
}
