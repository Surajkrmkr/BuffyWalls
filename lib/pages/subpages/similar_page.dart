import 'package:buffywalls_3/model/trending_popular.dart';
import 'package:buffywalls_3/provider/favourite.dart';
import 'package:buffywalls_3/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';
import '../../functions/download_wall.dart';
import '../../functions/random.dart';
import '../../functions/share.dart';
import '../../provider/ads.dart';
import '../../theme/my_flutter_app_icons.dart';
import '../../theme/ui_color.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/pro_dialog.dart';
import '../../widgets/scaffold.dart';
import '../imageview/image_view_page.dart';

// ignore: must_be_immutable
class SimilarPage extends StatelessWidget {
  SimilarPage({Key? key, @required this.index, @required this.imageList})
      : super(key: key);
  final int? index;
  final List<HomePageImage>? imageList;
  List<int>? l;

  @override
  Widget build(BuildContext context) {
    l = RandomWalls().bringRandomWalls(imageList!.length);
    return MyScaffold.getStaggeredScaffold(
      context: context,
      header: imageList![index!].name!,
      child: OrientationBuilder(builder: (context, orien) {
        return (orien == Orientation.portrait)
            ? Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Hero(
                                  tag: imageList![index!].heroId!,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: CNImage(
                                      imageUrl: imageList![index!].compressUrl!,
                                    ),
                                  )),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageViewPage(
                                                    imageList: imageList!,
                                                    index: index,
                                                  )));
                                    },
                                    splashColor: Provider.of<Uicolor>(context)
                                        .defaultAccentColor
                                        .withOpacity(0.3),
                                  ),
                                ),
                              ),
                              getBtnsRow(context),
                            ],
                          ),
                        ),
                        if (!ProDialog.appIsPro)
                          const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: BannerAdmob(),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: similarGridView(
                              physics: const NeverScrollableScrollPhysics()),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Hero(
                                  tag: imageList![index!].heroId!,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: CNImage(
                                      imageUrl: imageList![index!].compressUrl!,
                                    ),
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageViewPage(
                                                    imageList: imageList!,
                                                    index: index,
                                                  )));
                                    },
                                    splashColor: Provider.of<Uicolor>(context)
                                        .defaultAccentColor
                                        .withOpacity(0.3),
                                  ),
                                ),
                              ),
                              getBtnsRow(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      // width: MediaQuery.of(context).size.width * 0.5,
                      child: Scrollbar(
                        child: similarGridView(
                            physics: const AlwaysScrollableScrollPhysics()),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  Widget similarGridView({ScrollPhysics? physics}) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
        physics: physics,
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CNImage(
                  imageUrl: (imageList![l![i]].compressUrl) == null
                      ? imageList![l![i]].imageUrl
                      : imageList![l![i]].compressUrl,
                ),
                if (imageList![l![i]].isPremium!)
                  ProDialog.getCrown(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (imageList![l![i]].isPremium!) {Navigator.pushNamed(
                                                    context, "/proPage");
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageViewPage(
                                    imageList: imageList!,
                                    index: l![i],
                                  )));
                    },
                    splashColor: Provider.of<Uicolor>(context)
                        .defaultAccentColor
                        .withOpacity(0.3),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Padding getBtnsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0, right: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          (ProDialog.appIsPro)
              ? MyBottomSheet.bottomBtn(
                  context: context,
                  icon: Icons.favorite,
                  text: "Favorite",
                  onPressed: () {
                    Provider.of<FavouriteProvider>(context, listen: false)
                        .addToFav(
                            context: context,
                            imageData: imageList![index!],
                            category: imageList![index!].category);
                  })
              : MyBottomSheet.bottomBtn(
                  context: context,
                  icon: MyFlutterApp.share,
                  text: "Share",
                  onPressed: () {
                    ProDialog.appIsPro
                        ? MyShare.shareImage(imageList![index!].imageUrl!)
                        : MyShare.shareApp();
                  }),
          const SizedBox(width: 15),
          MyBottomSheet.bottomBtn(
              context: context,
              icon: MyFlutterApp.down,
              text: "Download",
              onPressed: () {
                DownloadImage.downloadImage(
                    context,
                    imageList![index!].imageUrl!,
                    imageList![index!].name!,
                    imageList![index!].heroId!);
              }),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
