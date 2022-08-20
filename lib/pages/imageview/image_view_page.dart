import 'package:buffywalls_3/provider/ads.dart';
import 'package:buffywalls_3/provider/color_palette.dart';
import 'package:buffywalls_3/provider/favourite.dart';
import 'package:buffywalls_3/provider/image_view.dart';
import 'package:buffywalls_3/widgets/bottom_sheet.dart';
import 'package:buffywalls_3/widgets/scaffold.dart';
import 'package:buffywalls_3/widgets/set_wall.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';
import '../../functions/download_wall.dart';
import '../../model/trending_popular.dart';
import '../../theme/my_flutter_app_icons.dart';
import '../../theme/ui_color.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/pro_dialog.dart';
import '../../widgets/snackbar.dart';

// ignore: must_be_immutable
class ImageViewPage extends StatelessWidget {
  ImageViewPage({Key? key, @required this.imageList, @required this.index})
      : super(key: key);
  // final HomePageImage? imageData;
  final List<HomePageImage>? imageList;
  final int? index;
  bool _initialized = false;
  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      Future.delayed(Duration.zero, () {
        Provider.of<ImageViewProvider>(context, listen: false)
            .getImageSize(imageList![index!].imageUrl);
        Provider.of<ImageViewProvider>(context, listen: false).isTap = true;
        _initialized = true;
      });

      if(!ProDialog.appIsPro) InterstitialsAds.showAd();
    }
    return MyScaffold.getScaffold(
        context: context,
        child: Consumer<ImageViewProvider>(
            builder: (context, imageViewProvider, _) {
          return PageView.builder(
              itemCount: imageList!.length,
              controller: PageController(initialPage: index!),
              itemBuilder: (context, i) {
                HomePageImage? imageData = imageList![i];
                Future.delayed(Duration.zero, () {
                  PaletteGeneratorProvider paletteProvider =
                      Provider.of<PaletteGeneratorProvider>(context,
                          listen: false);
                  imageList![i].compressUrl != null ||
                          imageList![i].compressUrl == ''
                      ? paletteProvider
                          .getColorPalette(imageList![i].compressUrl)
                      : paletteProvider.getColorPalette(imageList![i].imageUrl);
                });
                return Stack(
                  children: [
                    Hero(
                      tag: imageData.heroId!,
                      child: Center(
                        child: CachedNetworkImage(
                            errorWidget: (context, url, error) => errorWidget(),
                            filterQuality: FilterQuality.high,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            memCacheHeight:
                                MediaQuery.of(context).size.height.toInt(),
                            fit: BoxFit.cover,
                            imageUrl: imageData.imageUrl!,
                            placeholder: (context, url) {
                              return loadingWidget2();
                            }),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          imageViewProvider.isTap = !imageViewProvider.isTap;
                        },
                        onDoubleTap: () {
                          MyBottomSheet.getBottomSheet(context, imageData);
                        },
                        onLongPress: () {
                          MyBottomSheet.getBottomSheet(context, imageData);
                        },
                        splashColor: Provider.of<Uicolor>(context)
                            .defaultAccentColor
                            .withOpacity(0.3),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: imageViewProvider.isTap ? 1 : 0,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, right: 20),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    color: Colors.white,
                                    icon: const Icon(
                                      MyFlutterApp.back,
                                      size: 27,
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    }),
                                !ProDialog.appIsPro
                                    ? IconButton(
                                        color: Colors.white,
                                        icon: const Icon(
                                          Typicons.infinity,
                                          size: 27,
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                                    context, "/proPage");
                                        })
                                    : IconButton(
                                        icon: Icon(Icons.favorite,
                                            color: Uicolor.whiteColor),
                                        onPressed: () {
                                          Provider.of<FavouriteProvider>(
                                                  context,
                                                  listen: false)
                                              .addToFav(
                                                  context: context,
                                                  imageData: imageData,
                                                  category: imageData.category);
                                        }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: imageViewProvider.isTap ? 1 : 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 25.0, right: 15, left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MyBottomSheet.bottomBtn(
                                  context: context,
                                  icon: MyFlutterApp.wall,
                                  text: "Apply",
                                  onPressed: () {
                                    if (imageData.isPremium!) {
                                      MySnackBar.wallSnackBar(context,
                                          "Buy BuffyWalls pro to get this item");
                                      return;
                                    }
                                    showDialog(
                                        context: context,
                                        builder: (context) => SetWallDialog(
                                            url: imageData.imageUrl!));
                                  }),
                              const SizedBox(width: 15),
                              MyBottomSheet.bottomBtn(
                                  context: context,
                                  icon: MyFlutterApp.down,
                                  text: "Download",
                                  onPressed: () {
                                    if (imageData.isPremium!) {
                                      MySnackBar.wallSnackBar(context,
                                          "Buy BuffyWalls pro to get this item");
                                      return;
                                    }
                                    DownloadImage.downloadImage(
                                        context,
                                        imageData.imageUrl!,
                                        imageData.name!,
                                        imageData.heroId!);
                                  }),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        }));
  }
}
