import 'package:buffywalls_3/provider/setup.dart';
import 'package:buffywalls_3/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/setup.dart';
import '../../provider/ads.dart';
import '../../provider/image_view.dart';
import '../../theme/dark_theme.dart';
import '../../theme/ui_color.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/pro_dialog.dart';
import '../../widgets/scaffold.dart';
import '../../widgets/text_style.dart';
import '../imageview/setup_image_view_page.dart';

// ignore: must_be_immutable
class AllSetupPage extends StatelessWidget {
  bool _initialized = false;
  AllSetupPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // Future.delayed(Duration.zero, () {
      //   Provider.of<CategorizedProvider>(context, listen: false)
      //       .fetchDataFromUrl(domain!, name!);
      // });
      _initialized = true;
    }
    return MyScaffold.getStaggeredScaffold(
      context: context,
      header: "Setups",
      child: Stack(
        alignment: Alignment.center,
        children: [
          RefreshIndicator(
            backgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
                ? Uicolor.blackColor
                : Theme.of(context).backgroundColor,
            color: Provider.of<Uicolor>(context).defaultAccentColor,
            onRefresh: () async {},
            child: Consumer<SetupProvider>(
                builder: (context, setupProvider, child) {
              if (setupProvider.isLoading) return loadingWidget(context);
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
                            itemCount: setupProvider.imageList.length,
                            itemBuilder: (context, index) {
                              Setup image = setupProvider.imageList[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    CNImage(imageUrl: image.setupImageLink!),
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
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SetupImageViewPage(
                                                        setups: setupProvider
                                                            .imageList,
                                                        index: index,
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
