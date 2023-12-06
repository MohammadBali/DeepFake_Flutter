import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/Localization/Localization.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/styles/colors.dart';
import 'ManageUserSubscriptions.dart';

class GeneralSettings extends StatefulWidget {
  GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  List<String> listOfLanguages = ['ar','en'];

  String currentLanguage= AppCubit.language??='en';

  //String currentLanguage= 'en';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit= AppCubit.get(context);

          return Directionality(
            textDirection: AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  Localization.translate('appBar_title_general_settings'),
                  style:TextStyle(
                      color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                      fontFamily: 'WithoutSans',
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),

              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children:
                    [
                      Row(
                        children:
                        [
                          const Icon(
                            Icons.language,
                            size: 22,
                          ),

                          const SizedBox(width: 10,),

                          Expanded(
                            child: Text(
                              Localization.translate('language_general_Settings'),
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),

                          //const Spacer(),

                          Expanded(
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
                                      style: TextStyle(color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor),
                                      value: currentLanguage,
                                      isDense: true,
                                      onChanged: (newValue) {
                                        setState(() {
                                          print('Current Language is: $newValue');
                                          currentLanguage = newValue!;
                                          state.didChange(newValue);

                                          CacheHelper.saveData(key: 'language', value: newValue).then((value){

                                            //defaultToast(msg: 'App Will Restart Now to take effect');
                                            cubit.changeLanguage(newValue);
                                            Localization.load(Locale(newValue));

                                            // Timer(const Duration(seconds: 2), ()
                                            // {
                                            //   PhoenixNative.restartApp();
                                            // });

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

                        ],
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        children:
                        [
                          const Icon(Icons.perm_contact_cal_outlined, size: 22,),

                          const SizedBox(width: 10,),

                          Expanded(
                            child: Text(
                              Localization.translate('manage_your_subscriptions_settings'),
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),

                          //const Spacer(),

                          TextButton(
                            onPressed: ()
                            {
                              cubit.getSubscriptionsDetails();
                              navigateTo(context, const ManageUserSubscriptions());
                            },
                            child: Text(
                              Localization.translate('manage_your_subscriptions_button'),
                              style: TextStyle(
                                color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
