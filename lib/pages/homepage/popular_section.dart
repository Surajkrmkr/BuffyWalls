import 'package:buffywalls/api/trending_popular_model.dart';
import 'package:buffywalls/controller/trending_popular_controller.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/pages/image%20view%20page/image_view_page.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/error_widget.dart';
import 'package:buffywalls/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class PopularSection extends StatelessWidget {
  final PopularController popularController = Get.find<PopularController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (popularController.isPopularLoading.value)
        return loadingWidget();
      else
        return Padding(
          padding: const EdgeInsets.only(top: 25, right: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (context, i) {
                HomePageImage mydata = popularController.popularImageList[i];

                return Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Hero(
                    tag: mydata.heroId!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Material(
                        color: isAmoled
                            ? Uicolor.blackColor
                            : Get.theme.backgroundColor,
                        child: InkWell(
                          hoverColor: defaultAccentColor,
                          splashColor: Uicolor.blackColor.withOpacity(0.3),
                          onTap: () {
                            Get.to(ImageViewPage(imageData: mydata));
                          },
                          child: Container(
                            width: 130,
                            child: Material(
                              color: isAmoled
                                  ? Uicolor.blackColor
                                  : Get.theme.backgroundColor,
                              child: CachedNetworkImage(
                                filterQuality: FilterQuality.high,
                                errorWidget: (context, url, error) =>
                                    errorWidget(),
                                imageUrl: mydata.compressUrl != null
                                    ? mydata.compressUrl!
                                    : mydata.imageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, txt) => loadingWidget(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
    });
  }
}
