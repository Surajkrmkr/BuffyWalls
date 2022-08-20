import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/trending_popular.dart';
import '../../widgets/image.dart';
import '../../widgets/loading_widget.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<TrendingProvider>(
        builder: (context, trendingProvider, child) {
      if (trendingProvider.isLoading) {
        return loadingWidget(context);
      } else {
        return Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: ListView.builder(
                itemExtent: MediaQuery.of(context).size.width * 0.55,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: trendingProvider.imageList.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: MyImage.homeImageCard(
                        context: context,
                        index: i,
                        imageList: trendingProvider.imageList),
                  );
                }));
      }
    });
  }
}
