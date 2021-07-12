import 'package:buffywalls/api/setup_model.dart';
import 'package:buffywalls/controller/color_palette_controller.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/download_image.dart';
import 'package:buffywalls/widgets/set_wallpaper.dart';
import 'package:buffywalls/widgets/share.dart';
import 'package:buffywalls/widgets/snack_bar.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

rowContainer(IconData icon, String data) => Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Icon(icon, color: Uicolor.whiteColor),
        SizedBox(
          width: 15,
        ),
        Container(
          width: Get.width / 2 - 80,
          child: Text(
            data,
            style: MyTextStyle.bottomSheetTextStyleWithDefaultSize(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

class ImageBottomSheet extends StatelessWidget {
  ImageBottomSheet({this.imageData, this.isBrand, this.categoryName});
  final dynamic imageData;
  final bool? isBrand;
  final String? categoryName;

  final MyPaletteGeneratorController paletteGeneratorController = Get.find();
  @override
  Widget build(BuildContext context) {
    imageData!.compressUrl != null || imageData!.compressUrl == ''
        ? paletteGeneratorController.getColorPalette(imageData!.compressUrl)
        : paletteGeneratorController.getColorPalette(imageData!.imageUrl);
    return SolidBottomSheet(
      toggleVisibilityOnTap: true,
      smoothness: Smoothness.high,
      maxHeight: 300,
      headerBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GlassContainer(
          height: 50,
          width: Get.width,
          blur: 15,
          borderColor: Colors.transparent,
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: Center(
            child: Container(
              height: 8,
              width: 50,
              decoration: BoxDecoration(
                  color: Uicolor.whiteColor,
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ),
      ),
      body: Wrap(children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8),
          child: GlassContainer(
            width: Get.width,
            height: 300,
            blur: 15,
            borderColor: Colors.transparent,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Uicolor.blackColor.withOpacity(0.3),
                        radius: 25,
                        child: IconButton(
                            icon: Icon(MyFlutterApp.wall,
                                color: Uicolor.whiteColor),
                            onPressed: () {
                              setWallDialog(imageData.imageUrl);
                            }),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      CircleAvatar(
                        backgroundColor: Uicolor.blackColor.withOpacity(0.3),
                        radius: 25,
                        child: IconButton(
                            icon: Icon(MyFlutterApp.down,
                                color: Uicolor.whiteColor),
                            onPressed: () {
                              DownloadImage.downloadImage(
                                  imageData.imageUrl, imageData.name);
                            }),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      CircleAvatar(
                        backgroundColor: Uicolor.blackColor.withOpacity(0.3),
                        radius: 25,
                        child: IconButton(
                            icon: Icon(MyFlutterApp.share,
                                color: Uicolor.whiteColor),
                            onPressed: () {
                              shareImage(imageData.imageUrl);
                            }),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                    child: Align(
                        alignment: Alignment.center,
                        child: paletteGeneratorController.isLoading.value
                            ? LinearProgressIndicator()
                            : Wrap(
                                spacing: 8,
                                children: [
                                  paletteGeneratorController.getChip(
                                      0, paletteGeneratorController),
                                  paletteGeneratorController.getChip(
                                      1, paletteGeneratorController),
                                  paletteGeneratorController.getChip(
                                      2, paletteGeneratorController),
                                  paletteGeneratorController.getChip(
                                      3, paletteGeneratorController)
                                ],
                              )),
                  );
                }),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 25, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      imageData.name,
                      style: MyTextStyle.bodyTextStyle(
                          size: 20, color: Uicolor.whiteColor),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    rowContainer(MyFlutterApp.size, imageData.size),
                    rowContainer(MyFlutterApp.user, imageData.designer),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    rowContainer(MyFlutterApp.sheet,
                        isBrand! ? categoryName : imageData.category),
                    rowContainer(MyFlutterApp.tag, imageData.heroId),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

setupBottomSheet(Setup? imageData) {
  return SolidBottomSheet(
    toggleVisibilityOnTap: true,
    smoothness: Smoothness.high,
    maxHeight: 300,
    headerBar: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GlassContainer(
        height: 50,
        width: Get.width,
        blur: 15,
        borderColor: Colors.transparent,
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Center(
          child: Container(
            height: 8,
            width: 50,
            decoration: BoxDecoration(
                color: Uicolor.whiteColor,
                borderRadius: BorderRadius.circular(100)),
          ),
        ),
      ),
    ),
    body: GlassContainer(
      width: Get.width,
      height: 300,
      blur: 15,
      borderColor: Colors.transparent,
      color: Colors.transparent,
      child: ListView(
        children: [
          setupTile(
              name: imageData!.image,
              iconName: Icon(
                MyFlutterApp.wall,
                color: Uicolor.whiteColor,
                size: 30,
              ),
              onPressed: imageData.imageLink),
          setupTile(
              name: imageData.author,
              iconName: Icon(
                MyFlutterApp.user,
                color: Uicolor.whiteColor,
                size: 30,
              ),
              onPressed: imageData.authorLink),
          setupTile(
              name: imageData.launcher,
              iconName: Icon(
                MyFlutterApp.home,
                color: Uicolor.whiteColor,
                size: 30,
              ),
              onPressed: imageData.launcherLink),
          setupTile(
              name: imageData.kwgt,
              iconName: Icon(
                Icons.label_important,
                color: Uicolor.whiteColor,
                size: 30,
              ),
              onPressed: imageData.kwgtLink),
          setupTile(
              name: imageData.iconpack,
              iconName: Icon(
                Icons.android,
                color: Uicolor.whiteColor,
                size: 30,
              ),
              onPressed: imageData.iconpackLink),
        ],
      ),
    ),
  );
}

ListTile setupTile({String? name, Icon? iconName, String? onPressed}) {
  return ListTile(
      title: Text(
        name!.isEmpty ? "No Data" : name,
        style: MyTextStyle.bodyTextStyle(size: 18, color: Uicolor.whiteColor),
      ),
      onTap: () => onPressed!.isEmpty
          ? getSnackbar("No link", 'Has been provided')
          : launch(onPressed),
      trailing: Icon(
        Icons.north_east,
        color: Uicolor.whiteColor,
        size: 30,
      ),
      leading: iconName);
}
