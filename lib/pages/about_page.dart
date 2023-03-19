import 'package:buffywalls_3/functions/app_details.dart';
import 'package:buffywalls_3/functions/share.dart';
import 'package:buffywalls_3/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttericon/typicons_icons.dart';

import '../theme/dark_theme.dart';
import '../theme/ui_color.dart';
import '../widgets/text_style.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold.getStaggeredScaffold(
        context: context,
        header: "About BuffyWalls",
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        backgroundImage: AssetImage('assets/shadowteam.png')),
                    Text(
                      'Team Shadow',
                      style:
                          MyTextStyle.bodyTextStyle(context: context, size: 23),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Text(
                        'The aim of this application is to provide you stock and some cool categorised wallpapers ',
                        textAlign: TextAlign.center,
                        style: MyTextStyle.bodyTextStyle(
                            context: context,
                            size: 18,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                        iconSize: 35,
                        icon: Icon(
                          FontAwesome5.facebook,
                          color: Provider.of<DarkThemeProvider>(context)
                                  .amoledTheme
                              ? Uicolor.whiteColor
                              : Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () {
                          launchUrl(Uri.parse(AppDetails.fbHandle),
                              mode: LaunchMode.externalApplication);
                        }),
                    IconButton(
                        iconSize: 35,
                        icon: Icon(
                          FontAwesome5.twitter,
                          color: Provider.of<DarkThemeProvider>(context)
                                  .amoledTheme
                              ? Uicolor.whiteColor
                              : Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () {
                          launchUrl(Uri.parse(AppDetails.twitterHandle),
                              mode: LaunchMode.externalApplication);
                        }),
                    IconButton(
                        iconSize: 35,
                        icon: Icon(
                          Entypo.instagram,
                          color: Provider.of<DarkThemeProvider>(context)
                                  .amoledTheme
                              ? Uicolor.whiteColor
                              : Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () {
                          launchUrl(Uri.parse(AppDetails.instaHandle),
                              mode: LaunchMode.externalApplication);
                        })
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Follow us for the latest updates',
                    style: MyTextStyle.bodyTextStyle(
                        context: context,
                        size: 18,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Text(
                  'Support',
                  style: MyTextStyle.bodyTextStyle(
                      context: context,
                      size: 18,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              ListBody(
                children: <Widget>[
                  ListTile(
                      onTap: () {
                        launchUrl(Uri.parse(AppDetails.grpTG),
                            mode: LaunchMode.externalApplication);
                      },
                      leading: Icon(
                        Typicons.user_add,
                        color:
                            Provider.of<DarkThemeProvider>(context).amoledTheme
                                ? Uicolor.whiteColor
                                : Theme.of(context).colorScheme.onBackground,
                        size: 33,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30),
                      title: Text('FAQ',
                          style: MyTextStyle.bodyTextStyleWithDefaultSize(
                              context: context)),
                      subtitle: Text('Join our community at Telegram',
                          style: MyTextStyle.bodyTextStyleWithDefaultSize(
                              context: context))),
                  ListTile(
                      onTap: () {
                        launchUrl(Uri.parse(AppDetails.mailID),
                            mode: LaunchMode.externalApplication);
                      },
                      leading: Icon(
                        Typicons.warning,
                        color:
                            Provider.of<DarkThemeProvider>(context).amoledTheme
                                ? Uicolor.whiteColor
                                : Theme.of(context).colorScheme.onBackground,
                        size: 33,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30),
                      title: Text('Report Bugs',
                          style: MyTextStyle.bodyTextStyleWithDefaultSize(
                              context: context)),
                      subtitle: Text('Let us know where you find difficulty',
                          style: MyTextStyle.bodyTextStyleWithDefaultSize(
                              context: context))),
                ],
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                leading: Icon(
                  Icons.share,
                  color: Provider.of<DarkThemeProvider>(context).amoledTheme
                      ? Uicolor.whiteColor
                      : Theme.of(context).colorScheme.onBackground,
                  size: 33,
                ),
                title: Text('Share Us',
                    style: MyTextStyle.bodyTextStyleWithDefaultSize(
                        context: context)),
                subtitle: Text('Share our Cool wallpaper App',
                    style: MyTextStyle.bodyTextStyleWithDefaultSize(
                        context: context)),
                onTap: () {
                  MyShare.shareApp();
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Text('Creators',
                    style: MyTextStyle.bodyTextStyle(
                      context: context,
                      size: 18,
                      color: Theme.of(context).colorScheme.onBackground,
                    )),
              ),
              ListBody(
                children: <Widget>[
                  ListTile(
                      onTap: () {
                        launchUrl(Uri.parse(AppDetails.surajTG),
                            mode: LaunchMode.externalApplication);
                      },
                      leading: ClipOval(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.asset(
                            'assets/Dev/suraj.jpg',
                            height: 40,
                            fit: BoxFit.cover,
                          )),
                      trailing: Icon(
                        Typicons.right_open,
                        color:
                            Provider.of<DarkThemeProvider>(context).amoledTheme
                                ? Uicolor.whiteColor
                                : Theme.of(context).colorScheme.onBackground,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30),
                      title: Text(
                        'Suraj karmakar',
                        style: TextStyle(
                          fontFamily: 'Body',
                          color: Provider.of<DarkThemeProvider>(context)
                                  .amoledTheme
                              ? Uicolor.whiteColor
                              : Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      subtitle: Text(
                        'Student >> Android Developer',
                        style: TextStyle(
                            fontFamily: 'Body',
                            color: Provider.of<DarkThemeProvider>(context)
                                    .amoledTheme
                                ? Uicolor.whiteColor
                                : Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6)),
                      )),
                  ListTile(
                      onTap: () {
                        launchUrl(Uri.parse(AppDetails.piyushTG),
                            mode: LaunchMode.externalApplication);
                      },
                      leading: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.asset(
                          'assets/Dev/piyush.jpg',
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      trailing: Icon(
                        Typicons.right_open,
                        color:
                            Provider.of<DarkThemeProvider>(context).amoledTheme
                                ? Uicolor.whiteColor
                                : Theme.of(context).colorScheme.onBackground,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30),
                      title: Text(
                        'Piyush Varshney',
                        style: TextStyle(
                          fontFamily: 'Body',
                          color: Provider.of<DarkThemeProvider>(context)
                                  .amoledTheme
                              ? Uicolor.whiteColor
                              : Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      subtitle: Text(
                        'Student >> Designer',
                        style: TextStyle(
                            fontFamily: 'Body',
                            color: Provider.of<DarkThemeProvider>(context)
                                    .amoledTheme
                                ? Uicolor.whiteColor
                                : Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6)),
                      ))
                ],
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('Copyright Notice©',
                          style: MyTextStyle.bodyTextStyle(
                            context: context,
                            size: 23,
                            color: Theme.of(context).colorScheme.onBackground,
                          )),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Text(AppDetails.copyrightDesc,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: MyTextStyle.bodyTextStyle(
                            context: context,
                            size: 15,
                            color: Theme.of(context).colorScheme.onBackground,
                          )),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Text('Made in India ❤️',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: MyTextStyle.bodyTextStyle(
                            context: context,
                            size: 15,
                            color: Theme.of(context).colorScheme.onBackground,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
