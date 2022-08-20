import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buffywalls_3/functions/app_details.dart';
import 'package:buffywalls_3/functions/connectivty.dart';
import 'package:buffywalls_3/functions/download_wall.dart';
import 'package:buffywalls_3/functions/notifications.dart';
import 'package:buffywalls_3/functions/update_app.dart';
import 'package:buffywalls_3/provider/ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../functions/persistence.dart';
import '../functions/vibrate.dart';
import '../provider/trending_popular.dart';
import '../theme/dark_theme.dart';
import '../theme/my_flutter_app_icons.dart';
import '../theme/ui_color.dart';
import '../widgets/drawer.dart';
import '../widgets/pro_dialog.dart';
import '../widgets/scaffold.dart';
import '../widgets/text_style.dart';
import 'category_page.dart';
import 'homepage/category_section.dart';
import 'homepage/popular_section.dart';
import 'homepage/trending_section.dart';
import 'subpages/popular_trending_page.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  bool _initialized = false;
  ZoomDrawerController drawerController = ZoomDrawerController();

  HomePage({Key? key}) : super(key: key);

  // Future onRefresh() async {
  //   popularController.onRefresh();
  //   trendingController.onRefresh();
  // }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // IsPirated? isPirated;
      // checkPiracy(isPirated);
      Future.delayed(Duration.zero).then((_) {
        AwesomeNotifications().actionStream.listen((receivedAction) {
          switch (receivedAction.channelKey) {
            case "rating":
              ProDialog.appIsPro
                  ? launchUrl(Uri.parse(AppDetails.proAppUrl),
                      mode: LaunchMode.externalApplication)
                  : launchUrl(Uri.parse(AppDetails.appUrl),
                      mode: LaunchMode.externalApplication);

              break;
            case "download":
              receivedAction.payload!.forEach((key, val) {
                if (key == 'download') {
                  OpenFilex.open(val);
                }
              });
              break;
            default:
          }
        });
        if (!ProDialog.appIsPro) {
          InterstitialsAds.createAd();
        }
        MyConnectivity.checkConnectivity(context);
        MyUpdate.statusCheck(context);
        DownloadImage.getPermission(context);
        if (!RatingNotification().savedRatingNotify()) {
          MyNotifications().sendRatingNotification();
        }
      });
      _initialized = true;
    }
    return OrientationBuilder(builder: (context, orien) {
      return ZoomDrawer(
          controller: drawerController,
          style: DrawerStyle.defaultStyle,
          borderRadius: 25.0,
          angle: 0,
          slideWidth: (orien == Orientation.portrait)
              ? MediaQuery.of(context).size.width * 0.6
              : MediaQuery.of(context).size.width * 0.4,
          menuScreenWidth: (orien == Orientation.portrait)
              ? MediaQuery.of(context).size.width * 0.65
              : MediaQuery.of(context).size.width * 0.4,
          menuScreen: MyDrawer(
            drawerController: drawerController,
          ),
          mainScreen: MyScaffold.getScaffold(
              context: context,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 20.0, left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'BuffyWalls',
                                    style: MyTextStyle.headerTextStyle(context),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            MyFlutterApp.menu,
                                            color:
                                                Provider.of<DarkThemeProvider>(
                                                            context)
                                                        .amoledTheme
                                                    ? Uicolor.whiteColor
                                                    : Theme.of(context)
                                                        .primaryColor,
                                          ),
                                          onPressed: () {
                                            drawerController.toggle!();
                                          }),
                                      !ProDialog.appIsPro
                                          ? IconButton(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5),
                                              iconSize: 35,
                                              splashColor:
                                                  Provider.of<Uicolor>(context)
                                                      .defaultAccentColor
                                                      .withOpacity(0.3),
                                              icon: Icon(
                                                Typicons.infinity,
                                                color: Provider.of<Uicolor>(
                                                        context)
                                                    .defaultAccentColor,
                                              ),
                                              onPressed: () {
                                                // TODO - Pro Dialog
                                                // ProDialog().getProDialog();
                                              })
                                          : Container(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 20, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Vibrate.vibrate();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PopularTrending(
                                                    header: 'Top 15',
                                                    imageList: Provider.of<
                                                                PopularProvider>(
                                                            context,
                                                            listen: false)
                                                        .imageList,
                                                  )));
                                    },
                                    child: Text('Newest',
                                        style: MyTextStyle.bodyTextStyle(
                                            context: context,
                                            size: 17,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Vibrate.vibrate();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PopularTrending(
                                                    header: 'New',
                                                    imageList: Provider.of<
                                                                PopularProvider>(
                                                            context,
                                                            listen: false)
                                                        .imageList,
                                                  )));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 2),
                                      child: Text('All',
                                          style: MyTextStyle.bodyTextStyle(
                                            context: context,
                                            size: 17,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Flexible(flex: 2, child: PopularSection()),
                            if (orien == Orientation.portrait)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Vibrate.vibrate();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CategoryPage()));
                                  },
                                  child: Text('Categories',
                                      style: MyTextStyle.bodyTextStyle(
                                          context: context,
                                          size: 17,
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                              ),
                            if (orien == Orientation.portrait)
                              const Flexible(flex: 1, child: CategorySection()),
                            if (orien == Orientation.portrait)
                              GestureDetector(
                                onTap: () {
                                  Vibrate.vibrate();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PopularTrending(
                                                header: 'Trending',
                                                imageList: Provider.of<
                                                            TrendingProvider>(
                                                        context,
                                                        listen: false)
                                                    .imageList,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text('Trending now',
                                      style: MyTextStyle.bodyTextStyle(
                                          context: context,
                                          size: 17,
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                              ),
                            if (orien == Orientation.portrait)
                              const Flexible(flex: 2, child: TrendingSection()),
                            if (!ProDialog.appIsPro)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: BannerAdmob(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )));
    });

    // );
  }
}
