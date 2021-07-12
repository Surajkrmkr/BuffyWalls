import 'package:buffywalls/controller/setup_controller.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/pages/image%20view%20page/setup_image_view_page.dart';
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

class SetupPage extends StatelessWidget {
  final SetupController setupController = Get.find<SetupController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
        body: DoubleBack(
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
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20, left: 20, bottom: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Setup', style: MyTextStyle.headerTextStyle()),
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
                  Flexible(
                    child: Obx(
                      () {
                        if (setupController.isSetupLoading.value)
                          return loadingWidget();
                        else
                          return Swiper(
                            itemCount: setupController.setupImageList.length,
                            scale: 0.7,
                            viewportFraction: 0.6,
                            itemBuilder: (context, i) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    setupController.setupImageList[i].name,
                                    style: MyTextStyle.bodyTextStyle(size: 18),
                                  ),
                                  Text(
                                    'By ' +
                                        setupController
                                            .setupImageList[i].author,
                                    style: MyTextStyle.bodyTextStyle(size: 23),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.to(SetupViewPage(
                                        imageData:
                                            setupController.setupImageList[i])),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        height: Get.height / 2 + 100,
                                        imageUrl: setupController
                                            .setupImageList[i].setupImageLink,
                                        filterQuality: FilterQuality.high,
                                        errorWidget: (context, url, error) =>
                                            errorWidget(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, txt) =>
                                            loadingWidget(),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
