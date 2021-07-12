import 'package:buffywalls/api/trending_popular_model.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/pages/image%20view%20page/image_view_page.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/error_widget.dart';
import 'package:buffywalls/widgets/loading_widget.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';

class PopularTrending extends StatelessWidget {
  PopularTrending({this.header, this.imageList});
  final List<dynamic>? imageList;
  final String? header;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
      child: SafeArea(
        child: Column(
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
                    header!,
                    style: MyTextStyle.headerTextStyle(),
                  )),
                ],
              ),
            ),
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13)),
                    child: StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        itemCount: header == "Top 15" ? 15 : imageList!.length,
                        staggeredTileBuilder: (i) =>
                            // orientation == Orientation.portrait
                            //     ?
                            StaggeredTile.count(2, i.isEven ? 2 : 3),
                        // : StaggeredTile.count(1, i.isEven ? 2 : 3),
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 13,
                        itemBuilder: (context, i) {
                          return Hero(
                            tag: imageList![i].heroId,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Material(
                                color: isAmoled
                                    ? Uicolor.blackColor
                                    : Get.theme.backgroundColor
                                        .withOpacity(0.5),
                                child: InkWell(
                                    hoverColor: defaultAccentColor,
                                    splashColor: Get.theme.primaryColor,
                                    onTap: () {
                                      Get.to(ImageViewPage(
                                          imageData: imageList![i]));
                                    },
                                    child: CachedNetworkImage(
                                      filterQuality: FilterQuality.high,
                                      errorWidget: (context, url, error) =>
                                          errorWidget(),
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          imageList![i].compressUrl == null
                                              ? imageList![i].imageUrl
                                              : imageList![i].compressUrl,
                                      placeholder: (context, url) {
                                        return loadingWidget();
                                      },
                                    )),
                              ),
                            ),
                            // ),
                          );
                        }),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
