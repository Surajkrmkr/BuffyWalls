import 'package:buffywalls_3/model/category_brand_wall.dart';
import 'package:buffywalls_3/model/trending_popular.dart';
import 'package:buffywalls_3/pages/subpages/similar_page.dart';
import 'package:buffywalls_3/provider/category_brand_wall.dart';
import 'package:buffywalls_3/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';

import '../../provider/ads.dart';
import '../../provider/image_view.dart';
import '../../theme/dark_theme.dart';
import '../../theme/ui_color.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/pro_dialog.dart';
import '../../widgets/scaffold.dart';
import '../../widgets/text_style.dart';

// ignore: must_be_immutable
class CategoryWiseWalls extends StatelessWidget {
  bool _initialized = false;
  CategoryWiseWalls({Key? key, this.name, this.domain}) : super(key: key);
  final String? name;
  final String? domain;
  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      Future.delayed(Duration.zero, () {
        Provider.of<CategorizedProvider>(context, listen: false)
            .fetchDataFromUrl(domain!, name!);
      });
      _initialized = true;
    }
    return MyScaffold.getStaggeredScaffold(
      context: context,
      header: name,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RefreshIndicator(
            backgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
                ? Uicolor.blackColor
                : Theme.of(context).backgroundColor,
            color: Provider.of<Uicolor>(context).defaultAccentColor,
            onRefresh: () async {},
            child: Consumer<CategorizedProvider>(
                builder: (context, categorizedProvider, child) {
              if (categorizedProvider.isLoading) return loadingWidget(context);
              return Scrollbar(
                child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      child: OrientationBuilder(builder: (context, orien) {
                        return GridView.builder(
                            controller: Provider.of<ImageViewProvider>(context)
                                .scrollController,
                            shrinkWrap: true,
                            primary: false,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        (orien == Orientation.portrait) ? 2 : 5,
                                    childAspectRatio: 0.55,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15),
                            itemCount: categorizedProvider.imageList.length,
                            itemBuilder: (context, index) {
                              ImagesWall image =
                                  categorizedProvider.imageList[index];
                              return Hero(
                                tag: image.heroId!,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      CNImage(
                                          imageUrl: image.compressUrl == null
                                              ? image.imageUrl!
                                              : image.compressUrl!),
                                      Material(
                                        color: Colors.transparent,
                                        child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 30,
                                              width: 500,
                                              color: Colors.black26,
                                              child: Center(
                                                child: Text(
                                                  image.name!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      MyTextStyle.bodyTextStyle(
                                                          context: context,
                                                          size: 15,
                                                          color: Uicolor
                                                              .whiteColor),
                                                ),
                                              ),
                                            )),
                                      ),
                                      if (image.isPremium!)
                                         ProDialog.getCrown(),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            if (image.isPremium!) {
                                              Navigator.pushNamed(
                                                    context, "/proPage");
                                              return;
                                            }
                                            List<HomePageImage> imageList =
                                                categorizedProvider.imageList
                                                    .map((e) => HomePageImage(
                                                          imageUrl: e.imageUrl!,
                                                          compressUrl:
                                                              e.compressUrl,
                                                          name: e.name,
                                                          heroId: e.heroId,
                                                          category: name,
                                                          size: e.size,
                                                          designer: e.designer,
                                                          downloads:
                                                              e.downloads,
                                                          id: e.id,
                                                          isPremium: image.isPremium!
                                                        ))
                                                    .toList();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SimilarPage(
                                                            index: index,
                                                            imageList:
                                                                imageList)));
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
                            });
                      }),
                    )),
              );
            }),
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
