import 'package:buffywalls/controller/category_brand_controller.dart';
import 'package:buffywalls/controller/color_palette_controller.dart';
import 'package:buffywalls/controller/drawer_controller.dart';
import 'package:buffywalls/controller/setup_controller.dart';
import 'package:buffywalls/controller/trending_popular_controller.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/function/dark_mode.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/widgets/drawer.dart';
import 'package:buffywalls/widgets/update_app.dart';
import 'package:new_version/new_version.dart';
import 'package:buffywalls/widgets/app_details.dart';
import 'package:buffywalls/widgets/connectivity.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:buffywalls/pages/Homepage/category_section.dart';
import 'package:buffywalls/pages/Homepage/popular_section.dart';
import 'package:buffywalls/pages/Homepage/trending_section.dart';
import 'package:buffywalls/pages/category_page.dart';
import 'package:buffywalls/pages/subpages/popular_trending_page.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:buffywalls/widgets/vibrate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';
import 'package:is_pirated/is_pirated.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final MyDrawerController drawerController = Get.put(MyDrawerController());
  bool _initialized = false;
  final MyDarkMode myDarkMode = Get.put(MyDarkMode());
  final PopularController popularController = Get.put(PopularController());
  final CategoryController categoryController = Get.put(CategoryController());
  final SetupController setupController = Get.put(SetupController());
  final BrandController brandController = Get.put(BrandController());
  final TrendingController trendingController = Get.put(TrendingController());
  final FeatureController featureController = Get.put(FeatureController());
  final MyPaletteGeneratorController paletteGeneratorController =
      Get.put(MyPaletteGeneratorController());
  final AppDetails details = Get.put(AppDetails());
  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      checkConnectivity();
      details.getVersion();
      IsPirated? isPirated;
      checkPiracy(isPirated);
      final newVersion = NewVersion(
        androidId: ProDialog.appIsPro
            ? AppDetails.proPackageName
            : AppDetails.packageName,
      );
      statusCheck(newVersion);
      _initialized = true;
    }
    return ZoomDrawer(
      controller: drawerController.drawerController,
      style: DrawerStyle.DefaultStyle,
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      backgroundColor: Get.theme.backgroundColor,
      slideWidth: Get.width * 0.5,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
      menuScreen: Container(
        child: MyDrawer(),
      ),
      mainScreen: Scaffold(
        backgroundColor:
            isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
        body: DoubleBack(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isAmoled
                        ? [Uicolor.blackColor, Uicolor.blackColor]
                        : Get.isDarkMode
                            ? [
                                Get.theme.backgroundColor,
                                Get.theme.backgroundColor
                              ]
                            : Uicolor.bgGradient)),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Column(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'BuffyWalls',
                                  style: MyTextStyle.headerTextStyle(),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          MyFlutterApp.menu,
                                          color: isAmoled
                                              ? Uicolor.whiteColor
                                              : Get.theme.primaryColor,
                                        ),
                                        onPressed: () {
                                          drawerController
                                              .drawerController.toggle!();
                                        }),
                                    !ProDialog.appIsPro
                                        ? IconButton(
                                            padding: EdgeInsets.only(bottom: 5),
                                            iconSize: 35,
                                            splashColor: defaultAccentColor
                                                .withOpacity(0.3),
                                            icon: Icon(
                                              Typicons.infinity,
                                              color: defaultAccentColor,
                                            ),
                                            onPressed: () {
                                              ProDialog().getProDialog();
                                            })
                                        : Container(),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  vibrate();
                                  Get.to(
                                      PopularTrending(
                                        header: 'Top 15',
                                        imageList:
                                            popularController.popularImageList,
                                      ),
                                      transition: Transition.fadeIn,
                                      duration: Duration(milliseconds: 500));
                                },
                                child: Text('Newest',
                                    style: MyTextStyle.bodyTextStyle(
                                        size: 17,
                                        color: Get.theme.primaryColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 35.0),
                                child: GestureDetector(
                                  onTap: () {
                                    vibrate();
                                    Get.to(
                                        PopularTrending(
                                          header: 'New',
                                          imageList: popularController
                                              .popularImageList,
                                        ),
                                        transition: Transition.fadeIn,
                                        duration: Duration(milliseconds: 500));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(200),
                                      color: isAmoled
                                          ? Colors.transparent
                                          : Get.theme.primaryColorLight,
                                    ),
                                    child: Text('All',
                                        style: MyTextStyle.bodyTextStyle(
                                          size: 17,
                                          color: Get.theme.primaryColor,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Flexible(flex: 2, child: PopularSection()),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: () {
                                vibrate();
                                Get.to(CategoryPage(),
                                    transition: Transition.fadeIn,
                                    duration: Duration(milliseconds: 500));
                              },
                              child: Text('Categories',
                                  style: MyTextStyle.bodyTextStyle(
                                      size: 17, color: Get.theme.primaryColor)),
                            ),
                          ),
                          Flexible(flex: 1, child: CategorySection()),
                          GestureDetector(
                            onTap: () {
                              vibrate();
                              Get.to(
                                  PopularTrending(
                                    header: 'Trending',
                                    imageList:
                                        trendingController.trendingImageList,
                                  ),
                                  transition: Transition.fadeIn,
                                  duration: Duration(milliseconds: 500));
                            },
                            child: Text('Trending now',
                                style: MyTextStyle.bodyTextStyle(
                                    size: 17, color: Get.theme.primaryColor)),
                          ),
                          Flexible(flex: 2, child: TrendingSection()),
                          SizedBox(
                            height: 10,
                          )
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
}
