import 'package:deepfake_detection/modules/Login/login.dart';
import 'package:deepfake_detection/shared/components/components.dart';
import 'package:deepfake_detection/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class OnBoardingModel
{
  final String image;
  final String title;
  final String body;

  OnBoardingModel({required this.image, required this.title, required this.body});
}


class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  bool isLast=false;

  //Needs To Be Fixed
  List<OnBoardingModel> list=
  [
    OnBoardingModel(
        image: 'assets/json/on_board_1.json',
        title: 'Bored from Classic old Learning?',
        body: 'Reading grammar books and listening to teachers lecture can be quiet a drag.'
    ),

    OnBoardingModel(
        image: 'assets/json/on_board_2.json',
        title: 'Learn with Videos is The New Way of Learning !',
        body: 'Scientific researches has proven that videos contributes to a much more efficient learning than plain text'
    ),

    OnBoardingModel(
        image: 'assets/json/on_board_3.json',
        title: 'A Revolution in Language Learning',
        body: 'We offer a variety of video types to learn from, including movie scenes, songs, interviews and much more fun content!'
    ),

    OnBoardingModel(
        image: 'assets/json/on_board_4.json',
        title: 'Are You Ready ?',
        body: ''
    ),
  ];

  var pageViewController= PageController();

  void submit()
  {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value)  //Caching that we have already viewed the On Boarding
    {
      if(value==true)
      {
        navigateAndFinish(context, Login());
      }
    }
    );
  }

  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose()
  {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: AppBar(
        actions:
        [
          TextButton(
            onPressed: () => submit(),
            child: const Text('SKIP'),
          )
        ],
      ),
      body: Container(),
    );
  }
}
