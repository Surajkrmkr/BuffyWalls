import 'package:buffywalls_3/provider/trending_popular.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/category_brand.dart';
import '../provider/ads.dart';
import '../provider/category_brand.dart';
import '../theme/ui_color.dart';
import '../widgets/loading_widget.dart';
import '../widgets/pro_dialog.dart';
import '../widgets/scaffold.dart';
import '../widgets/text_style.dart';
import 'imageview/image_view_page.dart';
import 'subpages/category_wise_page.dart';

class BrandPage extends StatelessWidget {
  const BrandPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyScaffold.getScaffold(
        context: context,
        child: SafeArea(
          child: OrientationBuilder(builder: (context, orien) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, bottom: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Stock',
                          style: MyTextStyle.headerTextStyle(context)),
                      !ProDialog.appIsPro
                          ? IconButton(
                              padding: const EdgeInsets.only(bottom: 5),
                              iconSize: 35,
                              splashColor: Provider.of<Uicolor>(context)
                                  .defaultAccentColor
                                  .withOpacity(0.3),
                              icon: Icon(
                                Typicons.infinity,
                                color: Provider.of<Uicolor>(context)
                                    .defaultAccentColor,
                              ),
                              onPressed: () {
                                // ProDialog().getProDialog();
                              })
                          : Container(),
                    ],
                  ),
                ),
                (orien == Orientation.portrait)
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 20),
                        child: Text(
                          'Top Wallpapers',
                          style: MyTextStyle.bodyTextStyle(
                              context: context, size: 20),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CustomScrollView(
                      slivers: [
                        if (orien == Orientation.portrait)
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor: Colors.transparent,
                            expandedHeight: 200,
                            flexibleSpace: Container(
                                padding: const EdgeInsets.only(bottom: 15),
                                height: 200,
                                child: Consumer<FeatureProvider>(
                                    builder: (context, featureProvider, child) {
                                  if (featureProvider.isLoading) {
                                    return loadingWidget(context);
                                  }
                                  return Swiper(
                                    viewportFraction: 0.7,
                                    scale: 0.8,
                                    itemCount: featureProvider.imageList.length,
                                    itemBuilder: (context, i) {
                                      var data = featureProvider.imageList[i];
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            GestureDetector(
                                              // onTap: () => Get.to(() =>
                                              //     ImageViewPage(imageData: data)),
                                              child: CachedNetworkImage(
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          errorWidget(),
                                                  fit: BoxFit.cover,
                                                  memCacheWidth: 500,
                                                  placeholder: (context, url) {
                                                    return loadingWidget(
                                                        context);
                                                  },
                                                  imageUrl: data.imageUrl!),
                                            ),
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  launchUrl(
                                                      Uri.parse(
                                                          data.redirectUrl!),
                                                      mode: LaunchMode
                                                          .externalApplication);
                                                },
                                                splashColor:
                                                    Provider.of<Uicolor>(
                                                            context)
                                                        .defaultAccentColor
                                                        .withOpacity(0.3),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                })),
                          ),
                        SliverToBoxAdapter(child: Consumer<BrandProvider>(
                            builder: (context, brandProvider, child) {
                          if (brandProvider.isLoading) {
                            return loadingWidget(context);
                          }
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: GridView.builder(
                                primary: false,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            (orien == Orientation.portrait)
                                                ? 3
                                                : 5,
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 15,
                                        childAspectRatio:
                                            (orien == Orientation.portrait)
                                                ? 1 / 1.8
                                                : 1 / 1),
                                scrollDirection: Axis.vertical,
                                itemCount: brandProvider.imageList.length,
                                itemBuilder: (context, index) {
                                  CategoryBrand data =
                                      brandProvider.imageList[index];
                                  return SizedBox(
                                    height: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          CachedNetworkImage(
                                            filterQuality: FilterQuality.high,
                                            errorWidget:
                                                (context, url, error) =>
                                                    errorWidget(),
                                            fit: BoxFit.cover,
                                            memCacheHeight: 300,
                                            imageUrl: data.imageUrl!,
                                            placeholder: (context, url) {
                                              return loadingWidget(context);
                                            },
                                          ),
                                          Container(
                                              height: 1000,
                                              width: 1000,
                                              color: Colors.black38),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0,
                                                bottom: 12,
                                                left: 12),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(data.name!,
                                                  style:
                                                      MyTextStyle.bodyTextStyle(
                                                          context: context,
                                                          size: 15,
                                                          color: Uicolor
                                                              .whiteColor)),
                                            ),
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CategoryWiseWalls(
                                                              name: data.name,
                                                              domain: 'brands',
                                                            )));
                                              },
                                              splashColor:
                                                  Provider.of<Uicolor>(context)
                                                      .defaultAccentColor
                                                      .withOpacity(0.3),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        })),
                      ],
                    ),
                  ),
                ),
                if (!ProDialog.appIsPro)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: BannerAdmob(),
                  ),
              ],
            );
          }),
        ));
  }
}
