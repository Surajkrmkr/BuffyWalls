import 'package:buffywalls_3/functions/share.dart';
import 'package:buffywalls_3/model/setup.dart';
import 'package:buffywalls_3/provider/image_view.dart';
import 'package:buffywalls_3/widgets/bottom_sheet.dart';
import 'package:buffywalls_3/widgets/scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';
import '../../functions/download_wall.dart';
import '../../provider/ads.dart';
import '../../theme/my_flutter_app_icons.dart';
import '../../theme/ui_color.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/pro_dialog.dart';

// ignore: must_be_immutable
class SetupImageViewPage extends StatelessWidget {
  SetupImageViewPage({Key? key, @required this.setups, @required this.index})
      : super(key: key);
  // final Setup? imageData;
  final List<Setup>? setups;
  final int? index;
  bool _initialized = false;
  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      Future.delayed(Duration.zero, () {
        Provider.of<ImageViewProvider>(context, listen: false).isTap = true;
        InterstitialsAds.showAd();
        _initialized = true;
      });
    }
    return MyScaffold.getScaffold(
        context: context,
        child: PageView.builder(
            itemCount: setups!.length,
            restorationId: index.toString(),
            controller: PageController(initialPage: index!),
            itemBuilder: (context, i) {
              final Setup imageData = setups![i];
              return Consumer<ImageViewProvider>(
                  builder: (context, imageViewProvider, _) {
                return Stack(
                  children: <Widget>[
                    Center(
                      child: CachedNetworkImage(
                          errorWidget: (context, url, error) => errorWidget(),
                          filterQuality: FilterQuality.high,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          memCacheHeight:
                              MediaQuery.of(context).size.height.toInt(),
                          fit: BoxFit.cover,
                          imageUrl: imageData.setupImageLink!,
                          placeholder: (context, url) {
                            return loadingWidget2();
                          }),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          imageViewProvider.isTap = !imageViewProvider.isTap;
                        },
                        onDoubleTap: () {
                          MyBottomSheet.getSetupBottomSheet(context, imageData);
                        },
                        onLongPress: () {
                          MyBottomSheet.getSetupBottomSheet(context, imageData);
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
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10, right: 20),
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
                                    : const SizedBox(),
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
                                  icon: MyFlutterApp.share,
                                  text: "Share",
                                  onPressed: () {
                                    MyShare.shareImage(
                                        imageData.setupImageLink!);
                                  }),
                              const SizedBox(width: 15),
                              MyBottomSheet.bottomBtn(
                                  context: context,
                                  icon: MyFlutterApp.down,
                                  text: "Download",
                                  onPressed: () {
                                    DownloadImage.downloadImage(
                                        context,
                                        imageData.setupImageLink!,
                                        imageData.name!,
                                        imageData.id!.toString());
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
