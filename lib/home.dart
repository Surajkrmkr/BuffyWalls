import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/navigation.dart';
import 'package:buffywalls/pages/submit_page.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/vibrate.dart';
import 'package:flutter/material.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:get/get.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';

import 'function/amoled_mode.dart';

class Home extends StatelessWidget {
  final NavigationController navigationController =
      Get.put(NavigationController());

  // final MyDarkMode myDarkMode = Get.put(MyDarkMode());
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor:
            isAmoled ? Uicolor.blackColor : Get.theme.primaryColorLight,
        body: Obx(() {
          return navigationController
              .pages[navigationController.selectedItemPos.value];
        }),
        floatingActionButton: GradientFloatingActionButton(
          gradient: LinearGradient(
              colors: Uicolor.bgGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          onPressed: () {
            Get.to(SubmitPage());
          },
          child: Icon(
            MyFlutterApp.add,
            color: defaultAccentColor,
          ),
        ),
        //     FloatingActionButton(
        //   backgroundColor: Get.theme.backgroundColor,
        //   onPressed: () {},
        //   child: Icon(
        //     MyFlutterApp.add,
        //     color: defaultAccentColor,
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Obx(() {
          return SizedBox(
            height: 60,
            child: AnimatedBottomNavigationBar(
              icons: [
                MyFlutterApp.home,
                MyFlutterApp.setup,
                MyFlutterApp.category,
                MyFlutterApp.brand
              ],
              onTap: (index) {
                vibrate();
                navigationController.changeIndex(index);
              },
              activeColor: defaultAccentColor,
              backgroundColor:
                  isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.softEdge,
              leftCornerRadius: 25,
              rightCornerRadius: 25,
              splashColor: defaultAccentColor.withOpacity(0.5),
              activeIndex: navigationController.selectedItemPos.value,
            ),
          );
        }));
  }
}
