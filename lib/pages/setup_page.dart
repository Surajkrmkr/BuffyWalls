import 'package:buffywalls_3/pages/submit_page.dart';
import 'package:buffywalls_3/pages/subpages/all_setup_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ads.dart';
import '../provider/setup.dart';
import '../theme/ui_color.dart';
import '../widgets/loading_widget.dart';
import '../widgets/pro_dialog.dart';
import '../widgets/scaffold.dart';
import '../widgets/text_style.dart';
import 'imageview/setup_image_view_page.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyScaffold.getScaffold(
        context: context,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, bottom: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Setup', style: MyTextStyle.headerTextStyle(context)),
                    IconButton(
                        padding: const EdgeInsets.only(bottom: 5),
                        iconSize: 35,
                        icon: Icon(
                          Icons.send_rounded,
                          size: 30,
                          color:
                              Provider.of<Uicolor>(context).defaultAccentColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubmitPage()));
                        })
                  ],
                ),
              ),
              Flexible(
                child: Consumer<SetupProvider>(
                  builder: (context, setupProvider, child) {
                    if (setupProvider.isLoading) {
                      return loadingWidget(context);
                    } else {
                      return Swiper(
                        itemCount: 15,
                        scale: 0.7,
                        viewportFraction: 0.6,
                        itemBuilder: (context, i) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                setupProvider.imageList[i].name!,
                                style: MyTextStyle.bodyTextStyle(
                                    context: context, size: 18),
                              ),
                              Text(
                                setupProvider.imageList[i].author!,
                                style: MyTextStyle.bodyTextStyle(
                                    context: context,
                                    size: 23,
                                    color: Provider.of<Uicolor>(context)
                                        .defaultAccentColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Flexible(
                                child: OrientationBuilder(
                                    builder: (context, orien) {
                                  return Padding(
                                    padding: (orien == Orientation.portrait)
                                        ? const EdgeInsets.symmetric(
                                            vertical: 15.0)
                                        : const EdgeInsets.all(0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: setupProvider
                                                .imageList[i].setupImageLink!,
                                            filterQuality: FilterQuality.high,
                                            errorWidget:
                                                (context, url, error) =>
                                                    errorWidget(),
                                            memCacheHeight:
                                                (MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.8)
                                                    .toInt(),
                                            fit: BoxFit.cover,
                                            placeholder: (context, txt) =>
                                                loadingWidget(context),
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SetupImageViewPage(
                                                              setups:
                                                                  setupProvider
                                                                      .imageList,
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
                                  );
                                }),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllSetupPage()));
                        },
                        child: const Text('View All')),
                  ],
                ),
              ),
              if (!ProDialog.appIsPro)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: BannerAdmob(),
                ),
            ],
          ),
        ));
  }
}
