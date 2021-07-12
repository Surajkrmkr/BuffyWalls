import 'package:buffywalls/api/category_brand_model.dart';
import 'package:buffywalls/controller/category_brand_controller.dart';
import 'package:buffywalls/controller/category_brand_wall_controller.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/pages/subpages/category_wise_page.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/error_widget.dart';
import 'package:buffywalls/widgets/loading_widget.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';

class CategoryPage extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();
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
                        Text('Category', style: MyTextStyle.headerTextStyle()),
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
                  Obx(() {
                    if (categoryController.isLoading.value)
                      return loadingWidget();
                    return Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 1.7),
                                  itemCount:
                                      categoryController.imageList.length,
                                  itemBuilder: (context, index) {
                                    CategoryBrand data =
                                        categoryController.imageList[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        height: 100,
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
                                                        domain: 'Category',
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
