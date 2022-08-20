import 'package:buffywalls_3/model/trending_popular.dart';
import 'package:buffywalls_3/provider/image_view.dart';
import 'package:buffywalls_3/widgets/image.dart';
import 'package:buffywalls_3/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';

import '../../provider/ads.dart';
import '../../theme/dark_theme.dart';
import '../../theme/ui_color.dart';
import '../../widgets/pro_dialog.dart';
import '../imageview/image_view_page.dart';

class PopularTrending extends StatelessWidget {
  const PopularTrending({Key? key, this.header, this.imageList})
      : super(key: key);
  final List<HomePageImage>? imageList;
  final String? header;

  @override
  Widget build(BuildContext context) {
    return MyScaffold.getStaggeredScaffold(
      context: context,
      header: header,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RefreshIndicator(
            backgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
                ? Uicolor.blackColor
                : Theme.of(context).backgroundColor,
            color: Provider.of<Uicolor>(context).defaultAccentColor,
            onRefresh: () async {},
            // onRefresh: () => header == "Top 15"
            //     ? popularController.onRefresh()
            //     : trendingController.onRefresh(),
            child: Scrollbar(
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    child: OrientationBuilder(builder: (context, orien) {
                      return MasonryGridView.count(
                          controller: Provider.of<ImageViewProvider>(context)
                              .scrollController,
                          crossAxisCount:
                              (orien == Orientation.portrait) ? 2 : 5,
                          itemCount:
                              header == "Top 15" ? 15 : imageList!.length,
                          crossAxisSpacing: 13,
                          mainAxisSpacing: 13,
                          itemBuilder: (context, i) {
                            return Hero(
                              tag: imageList![i].heroId!,
                              child: SizedBox(
                                height: (i % 3.5 + 1) * 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CNImage(
                                          imageUrl: imageList![i].compressUrl ??
                                              imageList![i].imageUrl),
                                      if (imageList![i].isPremium!)
                                        ProDialog.getCrown(),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            if (imageList![i].isPremium!) {Navigator.pushNamed(
                                                    context, "/proPage");
                                              return;
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageViewPage(
                                                          imageList: imageList!,
                                                          index: i,
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
                              ),
                            );
                          });
                    }),
                  )),
            ),
          ),
          if (!ProDialog.appIsPro)
            const Positioned(
              bottom: 20,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: BannerAdmob(),
              ),
            ),
        ],
      ),
    );
  }
}
