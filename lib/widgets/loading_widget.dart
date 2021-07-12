import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget loadingWidget() => Center(
      child: Lottie.asset('assets/loading1.json',
          height: 100, width: 100, frameRate: FrameRate(30)),
    );

Widget loadingWidget2() => Center(
      child: Lottie.asset('assets/loading2.json', height: 150, width: 150),
    );
