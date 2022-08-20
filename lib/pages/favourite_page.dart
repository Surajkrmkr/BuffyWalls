import 'package:buffywalls_3/pages/imageview/image_view_page.dart';
import 'package:buffywalls_3/provider/favourite.dart';
import 'package:buffywalls_3/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/ui_color.dart';
import '../widgets/loading_widget.dart';
import '../widgets/scaffold.dart';
import '../widgets/text_style.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyScaffold.getStaggeredScaffold(
      header: "Favourite",
      context: context,
      child: Consumer<FavouriteProvider>(
          builder: (context, favouriteProvider, child) {
        if (favouriteProvider.favouriteList.isEmpty) {
          return emptyWidget(context);
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              child: OrientationBuilder(builder: (context, orien) {
                return GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (orien == Orientation.portrait) ? 2 : 5,
                        childAspectRatio: 0.55),
                    itemCount: favouriteProvider.favouriteList.length,
                    itemBuilder: (context, index) {
                      var image = favouriteProvider.favouriteList[index];
                      return Padding(
                        padding: index.isEven
                            ? const EdgeInsets.only(bottom: 15, right: 15)
                            : const EdgeInsets.only(bottom: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              CNImage(
                                imageUrl: image.compressUrl == null
                                    ? image.imageUrl!
                                    : image.compressUrl!,
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 30,
                                    width: 500,
                                    color: Colors.black26,
                                    child: Center(
                                      child: Text(
                                        image.name!,
                                        overflow: TextOverflow.ellipsis,
                                        style: MyTextStyle.bodyTextStyle(
                                            context: context,
                                            size: 15,
                                            color: Uicolor.whiteColor),
                                      ),
                                    ),
                                  )),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onLongPress: () {
                                    favouriteProvider.deleteWallFromFav(
                                        context: context, index: index);
                                  },
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => ImageViewPage(
                                                  imageList: favouriteProvider
                                                      .favouriteList,
                                                  index: index,
                                                )));
                                  },
                                  splashColor: Provider.of<Uicolor>(context)
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
            ),
          );
        }
      }),
    );
  }
}
