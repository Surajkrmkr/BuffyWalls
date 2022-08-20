import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../theme/ui_color.dart';

// Widget loadingWidget() => Center(
//       child: Lottie.asset('assets/Loading/loading1.json',
//           height: 100, width: 100, frameRate: FrameRate(30)),
//     );

//widget to be changed
Widget loadingWidget(context) => Center(
        child: SpinKitFadingCircle(
      color: Provider.of<Uicolor>(context).defaultAccentColor,
    ));

Widget loadingWidget2() => Center(
      child:
          Lottie.asset('assets/Loading/loading2.json', height: 150, width: 150),
    );

Widget errorWidget() => Center(
    child: Lottie.asset('assets/Loading/error.json', height: 150, width: 150));

Widget emptyWidget(context) => Center(
      child: Lottie.asset('assets/Loading/empty.json',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width),
    );
