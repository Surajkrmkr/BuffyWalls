import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';

import '../model/trending_popular.dart';
import '../pages/subpages/similar_page.dart';
import '../theme/ui_color.dart';
import 'loading_widget.dart';

class MyImage {
  static Widget homeImageCard(
      {BuildContext? context, int? index, List<HomePageImage>? imageList}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CNImage(
            imageUrl: imageList![index!].compressUrl != null
                ? imageList[index].compressUrl!
                : imageList[index].imageUrl!,
          ),
          if (imageList[index].isPremium!)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Typicons.infinity, color: Colors.white)),
            ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (imageList[index].isPremium!) {
                  return;
                }
                Navigator.push(
                    context!,
                    MaterialPageRoute(
                        builder: (context) => SimilarPage(
                            // currentImageData: mydata,
                            index: index,
                            imageList: imageList)));
              },
              splashColor: Provider.of<Uicolor>(context!)
                  .defaultAccentColor
                  .withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class CNImage extends StatelessWidget {
  const CNImage({Key? key, @required this.imageUrl}) : super(key: key);
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      filterQuality: FilterQuality.high,
      errorWidget: (context, url, error) => errorWidget(),
      fit: BoxFit.cover,
      memCacheHeight: 400,
      // memCacheWidth: 200,
      imageUrl: imageUrl!,
      placeholder: (context, url) {
        return loadingWidget(context);
      },
    );
  }
}
