import 'package:buffywalls/api/category_brand_model.dart';
import 'package:buffywalls/controller/category_brand_controller.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/pages/subpages/category_wise_page.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/error_widget.dart';
import 'package:buffywalls/widgets/loading_widget.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorySection extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (categoryController.isLoading.value)
        return loadingWidget();
      else
        return Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 5, 25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryController.imageList.length,
                    itemBuilder: (context, index) {
                      CategoryBrand data = categoryController.imageList[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Container(
                          height: 50,
                          width: 170,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Material(
                              color: Colors.black54,
                              child: InkWell(
                                hoverColor: defaultAccentColor,
                                splashColor: Colors.black.withOpacity(0.3),
                                onTap: () {
                                  Get.to(CategoryWiseWalls(
                                    name: data.name!,
                                    domain: 'Category',
                                  ));
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      filterQuality: FilterQuality.high,
                                      errorWidget: (context, url, error) =>
                                          errorWidget(),
                                      fit: BoxFit.cover,
                                      imageUrl: data.imageUrl!,
                                      placeholder: (context, url) {
                                        return loadingWidget();
                                      },
                                    ),
                                    Container(
                                        height: 1000,
                                        width: 1000,
                                        color: Colors.black38),
                                    Center(
                                      child: Text(data.name!,
                                          style: MyTextStyle.bodyTextStyle(
                                              size: 14,
                                              color: Uicolor.whiteColor)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })));
    });
  }
}
