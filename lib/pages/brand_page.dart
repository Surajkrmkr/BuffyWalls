import 'package:buffywalls/api/category_brand_model.dart';
import 'package:buffywalls/controller/category_brand_controller.dart';
import 'package:buffywalls/controller/trending_popular_controller.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/pages/image%20view%20page/image_view_page.dart';
import 'package:buffywalls/pages/subpages/category_wise_page.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/error_widget.dart';
import 'package:buffywalls/widgets/loading_widget.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:fluttericon/typicons_icons.dart';

import 'package:get/get.dart';

class BrandPage extends StatelessWidget {
  final BrandController brandController = Get.find<BrandController>();
  final FeatureController featureController = Get.find<FeatureController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
        child: DoubleBack(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20, left: 20, bottom: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Stock', style: MyTextStyle.headerTextStyle()),
                        !ProDialog.appIsPro
                            ? IconButton(
                                padding: EdgeInsets.only(bottom: 5),
                                iconSize: 35,
                                splashColor:
                                    defaultAccentColor.withOpacity(0.3),
                                icon: Icon(
                                  Typicons.infinity,
                                  color: defaultAccentColor,
                                ),
                                onPressed: () {
                                  ProDialog().getProDialog();
                                })
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 5),
                    child: Text(
                      'Top Wallpapers',
                      style: MyTextStyle.bodyTextStyle(size: 20),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      height: 200,
                      child: Obx(() {
                        if (featureController.isFeatureLoading.value)
                          return loadingWidget();
                        return Swiper(
                          viewportFraction: 0.7,
                          scale: 0.8,
                          itemCount: featureController.featureImageList.length,
                          itemBuilder: (context, i) {
                            var data = featureController.featureImageList[i];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: GestureDetector(
                                onTap: () =>
                                    Get.to(ImageViewPage(imageData: data)),
                                child: CachedNetworkImage(
                                    filterQuality: FilterQuality.high,
                                    errorWidget: (context, url, error) =>
                                        errorWidget(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) {
                                      return loadingWidget();
                                    },
                                    imageUrl: featureController
                                                .featureImageList[i]
                                                .compressUrl ==
                                            ''
                                        ? featureController
                                            .featureImageList[i].imageUrl
                                        : featureController
                                            .featureImageList[i].compressUrl),
                              ),
                            );
                          },
                        );
                      })),
                  Obx(() {
                    if (brandController.isLoading.value) return loadingWidget();
                    return Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 1 / 2),
                                  scrollDirection: Axis.vertical,
                                  itemCount: brandController.imageList.length,
                                  itemBuilder: (context, index) {
                                    CategoryBrand data =
                                        brandController.imageList[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        height: 150,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Material(
                                            color: Colors.black54,
                                            child: InkWell(
                                              hoverColor: defaultAccentColor,
                                              splashColor:
                                                  Colors.black.withOpacity(0.3),
                                              onTap: () {
                                                Get.to(
                                                    CategoryWiseWalls(
                                                        domain: 'brands',
                                                        name: data.name!),
                                                    transition:
                                                        Transition.fadeIn,
                                                    duration: Duration(
                                                        milliseconds: 500));
                                              },
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: <Widget>[
                                                  CachedNetworkImage(
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            errorWidget(),
                                                    fit: BoxFit.cover,
                                                    imageUrl: data.imageUrl!,
                                                    placeholder:
                                                        (context, url) {
                                                      return loadingWidget();
                                                    },
                                                  ),
                                                  Container(
                                                      height: 1000,
                                                      width: 1000,
                                                      color: Colors.black38),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 12.0,
                                                            bottom: 12,
                                                            left: 12),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(data.name!,
                                                          style: MyTextStyle
                                                              .bodyTextStyle(
                                                                  size: 15,
                                                                  color: Uicolor
                                                                      .whiteColor)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }))),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
