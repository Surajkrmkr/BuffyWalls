
import 'package:buffywalls/api/category_brand_wall_model.dart';
import 'package:buffywalls/controller/color_palette_controller.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/bottom_sheet.dart';
import 'package:buffywalls/widgets/error_widget.dart';
import 'package:buffywalls/widgets/loading_widget.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class ImageViewPage2 extends StatelessWidget {
  ImageViewPage2({@required this.imageData, @required this.categoryName});
  final ImagesWall? imageData;
  final String? categoryName;
  final MyPaletteGeneratorController paletteGeneratorController = Get.find();
  @override
  Widget build(BuildContext context) {
    // paletteGeneratorController.getColorPalette(imageData!.imageUrl);
    return Scaffold(
      backgroundColor:
          isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
      body: Container(
         decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:isAmoled? [Uicolor.blackColor,Uicolor.blackColor] : Get.isDarkMode 
                        ? [Get.theme.backgroundColor,Get.theme.backgroundColor]
                        : Uicolor.bgGradient)),
        child: Stack(
          children: <Widget>[
            Hero(
              tag: imageData!.heroId!,
              child:ZoomOverlay(
                minScale: 0.5, // Optional
                maxScale: 3.0, // Optional
                twoTouchOnly: true,
                child: CachedNetworkImage(
                      errorWidget: (context, url, error) => errorWidget(),
                      filterQuality: FilterQuality.high,
                      width: Get.width,
                      height: Get.height,
                      fit: BoxFit.cover,
                      imageUrl: imageData!.imageUrl!,
                      placeholder: (context, url) {
                        return loadingWidget2();
                      }),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                      splashColor: defaultAccentColor,
                      color: Colors.white,
                      icon: Icon(
                        MyFlutterApp.back,
                        size: 27,
                      ),
                      onPressed: () {
                        Get.back();
                      }),
                ),
              ),
            ),
            !ProDialog.appIsPro ?
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(right: 20, top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                        splashColor: defaultAccentColor,
                        color: Colors.white,
                        icon: Icon(
                          Typicons.infinity,
                          size: 27,
                        ),
                        onPressed: () {
                          ProDialog().getProDialog();
                        }),
                  ),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
      bottomSheet: ImageBottomSheet(imageData:imageData, isBrand:true,
                        categoryName: categoryName),
    );
  }
}
