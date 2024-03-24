import 'package:flutter/material.dart';

import '../../app/app.export.dart';
import '../../app/app.package.export.dart';
import '../../models/model_export.dart';
import '../common/common_export.dart';
import '../views/view_export.dart';

class CacheImage extends StatelessWidget {
  const CacheImage({Key? key, required this.imageUrl, this.fullView = false})
      : super(key: key);
  final String imageUrl;
  final bool fullView;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      filterQuality: FilterQuality.high,
      errorWidget: (context, url, error) => const Placeholder(),
      fit: BoxFit.cover,
      memCacheHeight: fullView ? 2340 : 800,
      imageUrl: imageUrl,
      placeholder: (context, url) {
        return const Placeholder();
      },
    );
  }
}

class BuffyImage extends StatelessWidget {
  final bool fullView;
  final double radius;
  final PopularWall wall;

  const BuffyImage(
      {super.key, required this.wall, this.fullView = false, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CacheImage(imageUrl: wall.imageUrl, fullView: fullView),
            Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () => locator<NavigationService>()
                        .navigateToImageView(wall: wall),
                    onLongPress: () {})),
            Positioned(
              right: 0,
              child: Visibility(
                visible: wall.isHot,
                replacement: Visibility(
                    visible: wall.isPremium, child: showTag(isPro: true)),
                child: showTag(),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: ViewModelBuilder<FavouriteViewModel>.reactive(
                  viewModelBuilder: () => locator<FavouriteViewModel>(),
                  disposeViewModel: false,
                  builder: (context, model, child) {
                    final isFavourite = model.isFavourite(wall.imageUrl);
                    return favouriteIcon(
                        onPressed: () => isFavourite
                            ? model.removeFavourite(wall.imageUrl)
                            : locator<HomeViewModel>()
                                .addFavourite(wall.imageUrl),
                        isFavourite: isFavourite);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

Widget favouriteIcon(
    {required bool isFavourite, required Function() onPressed}) {
  return IconButton.filledTonal(
    style: IconButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.2)),
    onPressed: onPressed,
    icon: Icon(
        isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
    color: isFavourite ? Colors.red : Colors.white,
  );
}

Widget showTag({bool isPro = false}) {
  return Container(
    height: 25,
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: isPro
              ? [const Color(0xFF0BB0E3), const Color(0xFF3603C6)]
              : [const Color(0xFFFF0000), const Color(0xFFFF8A00)]),
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      children: [
        Icon(
          isPro ? Icons.verified_rounded : Icons.local_fire_department_rounded,
          color: backgroundLight,
          size: 16,
        ),
        horizontalSpaceTiny,
        Text(isPro ? "Pro" : "Hot",
            style: const TextStyle(color: backgroundLight, fontSize: 12)),
      ],
    ),
  );
}
