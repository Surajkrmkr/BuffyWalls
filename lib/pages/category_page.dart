import 'package:buffywalls_3/provider/category_brand.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';
import '../model/category_brand.dart';
import '../provider/ads.dart';
import '../theme/ui_color.dart';
import '../widgets/loading_widget.dart';
import '../widgets/pro_dialog.dart';
import '../widgets/scaffold.dart';
import '../widgets/text_style.dart';
import 'subpages/category_wise_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyScaffold.getScaffold(
      context: context,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, bottom: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Category', style: MyTextStyle.headerTextStyle(context)),
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
                            // TODO ADD DIALOG
                            // ProDialog().getProDialog();
                          })
                      : Container(),
                ],
              ),
            ),
            Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
              if (categoryProvider.isLoading) {
                return loadingWidget(context);
              }
              return Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: OrientationBuilder(builder: (context, orien) {
                          return GridView.builder(
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          (orien == Orientation.portrait)
                                              ? 2
                                              : 5,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 1.7),
                              itemCount: categoryProvider.imageList.length,
                              itemBuilder: (context, index) {
                                CategoryBrand data =
                                    categoryProvider.imageList[index];
                                return SizedBox(
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        CachedNetworkImage(
                                          filterQuality: FilterQuality.high,
                                          errorWidget: (context, url, error) =>
                                              errorWidget(),
                                          fit: BoxFit.cover,
                                          memCacheHeight: 200,
                                          imageUrl: data.imageUrl!,
                                          placeholder: (context, url) {
                                            return loadingWidget(context);
                                          },
                                        ),
                                        // Container(
                                        //     height: 1000,
                                        //     width: 1000,
                                        //     color: Colors.black38),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       top: 12.0, bottom: 12, left: 12),
                                        //   child: Align(
                                        //     alignment: Alignment.bottomLeft,
                                        //     child: Text(data.name!,
                                        //         style: MyTextStyle.bodyTextStyle(
                                        //             size: 15,
                                        //             color: Uicolor.whiteColor)),
                                        //   ),
                                        // ),
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
                                                            domain: 'Category',
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
                              });
                        }))),
              );
            }),
            if (!ProDialog.appIsPro)
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: BannerAdmob(),
              ),
          ],
        ),
      ),
    );
  }
}
