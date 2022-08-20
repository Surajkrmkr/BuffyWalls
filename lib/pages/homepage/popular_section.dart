import 'package:buffywalls_3/provider/trending_popular.dart';
import 'package:buffywalls_3/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/loading_widget.dart';

class PopularSection extends StatelessWidget {
  const PopularSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PopularProvider>(
        builder: (context, popularProvider, child) {
      if (popularProvider.isLoading) {
        return loadingWidget(context);
      } else {
        return Padding(
            padding: const EdgeInsets.only(top: 25),
            child: OrientationBuilder(builder: (context, orien) {
              return ListView.builder(
                  itemExtent: MediaQuery.of(context).size.width * 0.35,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: MyImage.homeImageCard(
                          context: context,
                          index: i,
                          imageList: popularProvider.imageList),
                    );
                  });
            }));
      }
    });
  }
}
