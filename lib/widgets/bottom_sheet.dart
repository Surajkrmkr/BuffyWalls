import 'package:buffywalls_3/functions/share.dart';
import 'package:buffywalls_3/model/setup.dart';
import 'package:buffywalls_3/provider/color_palette.dart';
import 'package:buffywalls_3/provider/image_view.dart';
import 'package:buffywalls_3/widgets/pro_dialog.dart';
import 'package:buffywalls_3/widgets/set_wall.dart';
import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../functions/download_wall.dart';
import '../model/trending_popular.dart';
import '../theme/dark_theme.dart';
import '../theme/my_flutter_app_icons.dart';
import '../theme/ui_color.dart';

class MyBottomSheet {
  static getBottomSheet(BuildContext? context, HomePageImage? imageData) =>
      showModalBottomSheet(
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          context: context!,
          builder: (context) {
            return Wrap(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  imageData!.name!,
                                  style: MyTextStyle.bodyTextStyle(
                                    size: 25,
                                    context: context,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(imageData.designer!,
                                  style: MyTextStyle.bodyTextStyle(
                                      context: context, size: 15)),
                            ],
                          ),
                        ),
                        getDivider(context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            bottomSheetBtn(
                                context: context,
                                icon: MyFlutterApp.wall,
                                onPressed: () {
                                  if (imageData.isPremium!) {
                                    MySnackBar.wallSnackBar(context,
                                        "Buy BuffyWalls pro to get this item");
                                    return;
                                  }
                                  showDialog(
                                      context: context,
                                      builder: (context) => SetWallDialog(
                                          url: imageData.imageUrl!));
                                }),
                            bottomSheetBtn(
                                context: context,
                                icon: MyFlutterApp.down,
                                onPressed: () {
                                  if (imageData.isPremium!) {
                                    MySnackBar.wallSnackBar(context,
                                        "Buy BuffyWalls pro to get this item");
                                    return;
                                  }
                                  DownloadImage.downloadImage(
                                      context,
                                      imageData.imageUrl!,
                                      imageData.name!,
                                      imageData.heroId!);
                                }),
                            bottomSheetBtn(
                                context: context,
                                icon: MyFlutterApp.share,
                                onPressed: () {
                                  if (imageData.isPremium!) {
                                    MySnackBar.wallSnackBar(context,
                                        "Buy BuffyWalls pro to get this item");
                                    return;
                                  }
                                  ProDialog.appIsPro
                                      ? MyShare.shareImage(imageData.imageUrl!)
                                      : MyShare.shareApp();
                                }),
                          ],
                        ),
                        getDivider(context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    rowContainer(
                                        context: context,
                                        icon: MyFlutterApp.size,
                                        data: imageData.size),
                                    rowContainer(
                                        context: context,
                                        icon: Icons.width_full,
                                        data:
                                            "${Provider.of<ImageViewProvider>(context).imageWidth} x ${Provider.of<ImageViewProvider>(context).imageHeight}"),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    rowContainer(
                                        context: context,
                                        icon: MyFlutterApp.category,
                                        data: imageData.category),
                                    rowContainer(
                                        context: context,
                                        icon: MyFlutterApp.tag,
                                        data: imageData.heroId),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        getDivider(context),
                        const ColorPalette(),
                      ],
                    )),
              ],
            );
          });

  static getSetupBottomSheet(BuildContext? context, Setup? imageData) =>
      showModalBottomSheet(
          context: context!,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          builder: (context) {
            return Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20),
                  child: Column(
                    children: [
                      SetupTile(
                          name: imageData!.image,
                          iconName: MyFlutterApp.wall,
                          data: imageData.imageLink),
                      SetupTile(
                          name: imageData.author,
                          iconName: MyFlutterApp.user,
                          data: imageData.authorLink),
                      SetupTile(
                          name: imageData.launcher,
                          iconName: MyFlutterApp.home,
                          data: imageData.launcherLink),
                      SetupTile(
                          name: imageData.kwgt,
                          iconName: Icons.label_important,
                          data: imageData.kwgtLink),
                      SetupTile(
                          name: imageData.iconpack,
                          iconName: Icons.android,
                          data: imageData.iconpackLink),
                    ],
                  ),
                )
              ],
            );
          });

  static Padding getDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(
        thickness: 2,
        indent: 100,
        endIndent: 100,
        color: Theme.of(context).primaryColor.withOpacity(0.0),
      ),
    );
  }

  static Widget bottomSheetBtn(
      {BuildContext? context, IconData? icon, Function()? onPressed}) {
    return FloatingActionButton(
        backgroundColor: Theme.of(context!).primaryColorDark,
        foregroundColor: Colors.white,
        onPressed: onPressed,
        child: Icon(icon));
  }

  static Widget bottomBtn(
      {BuildContext? context,
      IconData? icon,
      String? text,
      Function()? onPressed}) {
    return Expanded(
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context!).primaryColor,
                backgroundColor:
                    Provider.of<DarkThemeProvider>(context).amoledTheme
                        ? Uicolor.blackColor
                        : Theme.of(context).primaryColorLight),
          ),
          child: ElevatedButton(
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 25,
                    color: Provider.of<DarkThemeProvider>(context).amoledTheme
                        ? Uicolor.whiteColor
                        : Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Text(text!,
                      style: MyTextStyle.bodyTextStyle(
                          context: context, size: 15)),
                ],
              )),
        ),
      ),
    );
  }

  static rowContainer({BuildContext? context, IconData? icon, String? data}) =>
      Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            icon,
            color: Provider.of<DarkThemeProvider>(context!).amoledTheme
                ? Uicolor.whiteColor
                : Theme.of(context).primaryColor,
            size: 25,
          ),
          const SizedBox(
            width: 15,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 80,
            child: Text(
              data!,
              style: MyTextStyle.bodyTextStyle(context: context, size: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}

class SetupTile extends StatelessWidget {
  const SetupTile({Key? key, this.name, this.iconName, this.data})
      : super(key: key);

  final String? name;
  final IconData? iconName;
  final String? data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        name!.isEmpty ? "No Data" : name!,
        overflow: TextOverflow.ellipsis,
        style: MyTextStyle.bodyTextStyle(context: context, size: 18),
      ),
      onTap: () => data!.isEmpty
          ? MySnackBar.wallSnackBar(context, 'No Link Available')
          : launchUrl(Uri.parse(data!), mode: LaunchMode.externalApplication),
      trailing: Icon(
        Icons.navigate_next_rounded,
        size: 30,
        color: Provider.of<DarkThemeProvider>(context).amoledTheme
            ? Uicolor.whiteColor
            : Theme.of(context).primaryColor,
      ),
      leading: Icon(
        iconName,
        color: Provider.of<DarkThemeProvider>(context).amoledTheme
            ? Uicolor.whiteColor
            : Theme.of(context).primaryColor,
        size: 30,
      ),
    );
  }
}

class ColorPalette extends StatelessWidget {
  const ColorPalette({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Swatches',
          style: MyTextStyle.bodyTextStyle(context: context, size: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        Consumer<PaletteGeneratorProvider>(
          builder: (context, paletteProvider, _) => paletteProvider.isLoading
              ? const Center(child: LinearProgressIndicator())
              : Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: (paletteProvider.color.length >= 4)
                      ? List.generate(
                          paletteProvider.color.length,
                          (index) => paletteProvider.getChip(
                              context, index, paletteProvider))
                      : [
                          Text("Error occured while fetching colors",
                              style: MyTextStyle
                                  .bottomSheetTextStyleWithDefaultSize()),
                        ]),
        )
      ],
    );
  }
}
