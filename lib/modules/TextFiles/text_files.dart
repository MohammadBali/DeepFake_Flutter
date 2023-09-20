import 'package:deepfake_detection/layout/cubit/cubit.dart';
import 'package:deepfake_detection/layout/cubit/states.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:string_extensions/string_extensions.dart';

class TextFiles extends StatelessWidget {
  const TextFiles({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Row(
                  children: [
                    Text(
                      'Upload Text File',
                      style: TextStyle(
                        color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                        fontSize: 32,
                        fontFamily: 'Neology',
                      ),
                    ),

                    const Spacer(),

                    Visibility(
                      visible: cubit.chosenFile !=null,
                      child: IconButton(
                        onPressed: ()
                        {
                          cubit.removeFile();
                        },
                        icon: Icon(
                          Icons.remove,
                          color: cubit.isDarkTheme? defaultDarkColor : defaultColor,

                        )
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25,),
                
                const Text(
                  'Choose a File to Upload',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    wordSpacing: 2
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                ),

                const SizedBox(height: 100,),

                Center(
                  child: cubit.chosenFile ==null ? SizedBox(
                    height: MediaQuery.of(context).size.height /5,
                    width: MediaQuery.of(context).size.width /2,
                    child: defaultBox(
                      cubit: cubit,
                      boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                      borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor.withOpacity(0.9) : defaultSecondaryColor.withOpacity(0.9),
                      manualBorderColor: true,
                      child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 35,
                          )
                      ),
                      onTap: ()
                      {
                        cubit.pickFile();
                      },
                    ),
                  ) :
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
                    child: SizedBox(
                      child: defaultBox(
                        padding: 28,
                        cubit: cubit,
                        boxColor: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children:
                          [
                            Expanded(
                              child: Text(
                                cubit.chosenFile!.name.capitalize!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: cubit.isDarkTheme? defaultSecondaryDarkColor : Colors.white,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(width: 5,),

                            const Icon(Icons.file_copy_outlined),
                          ],
                        ),
                        onTap: ()
                        async {
                          openFile(cubit.chosenFile!.path!);
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 75,),

                Center(
                  child: defaultButton(
                    title: 'UPLOAD',
                    color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
                    onTap: ()
                    {
                      if(cubit.chosenFile!=null)
                      {

                      }
                      else
                      {
                        defaultToast(msg: 'No Data to Upload');
                      }
                    },
                    textColor: cubit.isDarkTheme? Colors.black : Colors.white,
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }


}
