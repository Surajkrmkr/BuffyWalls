import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/app_details.dart';
import '../theme/my_flutter_app_icons.dart';
import '../theme/ui_color.dart';
import '../widgets/pro_dialog.dart';
import '../widgets/scaffold.dart';
import '../widgets/text_style.dart';

class ProPage extends StatelessWidget {
  const ProPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold.getScaffold(
        context: context,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 45.0, left: 25),
                child: IconButton(
                    color: Provider.of<Uicolor>(context).defaultAccentColor,
                    icon: const Icon(
                      MyFlutterApp.back,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/logo_cropped.png",
                        width: 100,
                      ),
                      Text(
                        "BuffyWalls Pro",
                        style: MyTextStyle.headerTextStyle(context)
                            .copyWith(fontSize: 35),
                      ),
                      Text(
                        "Upgrade Now",
                        style: MyTextStyle.bodyTextStyleWithDefaultSize(
                                context: context)
                            .copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Swiper(
                      scale: 0.7,
                      viewportFraction: 0.6,
                      itemCount: ProDialog.pages(context).length,
                      itemBuilder: (context, i) {
                        return ProDialog.pages(context)[i];
                      }),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButtonTheme(
                    data: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                          primary:
                              Provider.of<Uicolor>(context).defaultAccentColor,
                          onPrimary: Theme.of(context).primaryColor),
                    ),
                    child: ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse(AppDetails.proAppUrl),
                              mode: LaunchMode.externalApplication);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Buy Now",
                                style: MyTextStyle
                                        .bottomSheetTextStyleWithDefaultSize()
                                    .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
