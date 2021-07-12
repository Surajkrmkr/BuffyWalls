import 'package:buffywalls/api/category_brand_wall_model.dart';
import 'package:buffywalls/controller/category_brand_wall_controller.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/pages/image%20view%20page/category_image_view_page.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/error_widget.dart';
import 'package:buffywalls/widgets/loading_widget.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryWiseWalls extends StatelessWidget {
  CategoryWiseWalls({this.name, this.domain});
  final CategorizedController categorizedController =
      Get.put(CategorizedController());
  final String? name;
  final String? domain;
  @override
  Widget build(BuildContext context) {
    categorizedController.fetchDataFromUrl(domain!, name!);
    return Material(
      color: isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: IconButton(
                        splashColor: defaultAccentColor.withOpacity(0.3),
                        color: defaultAccentColor,
                        icon: Icon(
                          MyFlutterApp.back,
                        ),
                        onPressed: () {
                          Get.back();
                        }),
                  ),
                  Align(
                      child: Text(
                    name!,
                    style: MyTextStyle.headerTextStyle(),
                  )),
                ],
              ),
            ),
            Obx(() {
              if (categorizedController.isLoading.value)
                return Flexible(child: loadingWidget());
              return Flexible(
                child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(13)),
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: categorizedController.imageList.length,
                          itemBuilder: (context, index) {
                            ImagesWall image =
                                categorizedController.imageList[index];
                            return Padding(
                              padding: index.isEven
                                  ? EdgeInsets.only(bottom: 15, right: 15)
                                  : EdgeInsets.only(bottom: 15),
                              child: Hero(
                                tag: image.heroId!,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Material(
                                    color: isAmoled
                                        ? Uicolor.blackColor
                                        : Get.theme.backgroundColor,
                                    child: InkWell(
                                        hoverColor: defaultAccentColor,
                                        splashColor: Get.theme.primaryColor,
                                        onTap: () {
                                          Get.to(ImageViewPage2(
                                              imageData: image,
                                              categoryName: name));
                                        },
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: <Widget>[
                                            CachedNetworkImage(
                                              errorWidget:
                                                  (context, url, error) =>
                                                      errorWidget(),
                                              filterQuality: FilterQuality.none,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  image.compressUrl == null
                                                      ? image.imageUrl!
                                                      : image.compressUrl!,
                                              placeholder: (context, url) {
                                                return loadingWidget();
                                              },
                                            ),
                                            Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  height: 30,
                                                  width: 500,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      image.name!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: MyTextStyle
                                                          .bodyTextStyle(
                                                              size: 15,
                                                              color: Uicolor
                                                                  .whiteColor),
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )),
              );
            })
          ],
        ),
      ),
    );
  }
}
