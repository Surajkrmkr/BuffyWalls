import 'package:buffywalls_3/theme/ui_color.dart';
import 'package:buffywalls_3/widgets/blobs.dart';
import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:provider/provider.dart';

import '../home.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Stack(
        alignment: Alignment.center,
        children: [
          OnBoardingSlider(
            controllerColor: Provider.of<Uicolor>(context).defaultAccentColor,
            headerBackgroundColor: Colors.white,
            pageBackgroundColor: Colors.transparent,
            finishButtonText: 'Continue',
            skipTextButton: const Text("Skip"),
            finishButtonColor: Provider.of<Uicolor>(context).defaultAccentColor,
            onFinish: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            background: [
              onBoardPng(context: context, name: '1'),
              onBoardPng(context: context, name: '2'),
              onBoardPng(context: context, name: '3'),
              onBoardPng(context: context, name: '4'),
            ],
            totalPage: 4,
            speed: 1.8,
            pageBodies: [
              Padding(
                padding: const EdgeInsets.only(top: 130.0),
                child: onBoardHeader(
                  txt1: "Welcome to",
                  txt2: "BuffyWalls",
                  txt1Height: 25,
                  txt2Height: 40,
                  context: context,
                ),
              ),
              onBoardHeader(
                  context: context,
                  txt1: "Wallpapers",
                  txt2: "Endless Collection",
                  txt1Height: 40,
                  txt2Height: 25),
              onBoardHeader(
                  context: context,
                  txt1: "Setups",
                  txt2: "Amazing Collection Of\nHomescreen Setups",
                  txt1Height: 40,
                  txt2Height: 25),
              onBoardHeader(
                  context: context,
                  txt1: "View",
                  txt2: "Every Single Detail on\nYour Fingertips",
                  txt1Height: 40,
                  txt2Height: 25),
            ],
          ),
          Positioned(bottom: -100, left: -100, child: MyBlob.getBlob(context)),
          Positioned(top: 100, right: -100, child: MyBlob.getBlob(context)),
          Positioned(top: 0, left: -150, child: MyBlob.getBlob(context)),
        ],
      );
    });
  }

  Center onBoardHeader(
      {String? txt1,
      String? txt2,
      double? txt1Height,
      double? txt2Height,
      BuildContext? context}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 100,
          ),
          Text(
            txt1!,
            style:
                MyTextStyle.bodyTextStyle(context: context, size: txt1Height),
          ),
          Text(
            txt2!,
            style:
                MyTextStyle.bodyTextStyle(context: context, size: txt2Height),
          ),
        ],
      ),
    );
  }

  SizedBox onBoardPng({BuildContext? context, String? name}) {
    return SizedBox(
      height: MediaQuery.of(context!).size.height,
      child: Image.asset(
        'assets/onBoard/$name.png',
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
