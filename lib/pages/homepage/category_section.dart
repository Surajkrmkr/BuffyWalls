import 'dart:ui';

import 'package:buffywalls_3/provider/category_brand.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/category_brand.dart';
import '../../theme/ui_color.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/text_style.dart';
import '../subpages/category_wise_page.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
      if (categoryProvider.isLoading) {
        return loadingWidget(context);
      } else {
        return Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 20),
            child: ListView.builder(
                itemExtent: MediaQuery.of(context).size.width * 0.45,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categoryProvider.imageList.length,
                itemBuilder: (context, index) {
                  CategoryBrand mydata = categoryProvider.imageList[index];
                  return Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              filterQuality: FilterQuality.high,
                              errorWidget: (context, url, error) =>
                                  errorWidget(),
                              fit: BoxFit.cover,
                              imageUrl: mydata.imageUrl!,
                              placeholder: (context, url) {
                                return loadingWidget(context);
                              },
                            ),
                            Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.black38),
                            Center(
                              child: Text(mydata.name!,
                                  style: MyTextStyle.bodyTextStyle(
                                      size: 14,
                                      color: Uicolor.whiteColor,
                                      context: context)),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CategoryWiseWalls(
                                                name: mydata.name,
                                                domain: 'Category',
                                              )));
                                },
                                splashColor: Provider.of<Uicolor>(context)
                                    .defaultAccentColor
                                    .withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ));
                }));
      }
    });
  }
}
