import 'package:buffywalls_3/pages/favourite_page.dart';
import 'package:buffywalls_3/provider/navigation.dart';
import 'package:buffywalls_3/theme/dark_theme.dart';
import 'package:buffywalls_3/widgets/pro_dialog.dart';
import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'functions/vibrate.dart';
import 'theme/my_flutter_app_icons.dart';
import 'theme/ui_color.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DoubleBackToCloseApp(
          snackBar: MySnackBar.getSnackBar(context, "Press again to exit"),
          child: Provider.of<NavigationProvider>(context, listen: false).pages[
              Provider.of<NavigationProvider>(context, listen: true)
                  .getSelectedItemPos()],
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
              ? Uicolor.blackColor
              : Theme.of(context).primaryColorLight,
          onPressed: () {
            if (ProDialog.appIsPro) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FavouritePage()));
            } else {
              Navigator.pushNamed(context, "/proPage");
            }
          },
          child: Icon(
            Icons.favorite,
            color: Provider.of<Uicolor>(context).defaultAccentColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: AnimatedBottomNavigationBar(
            icons: const [
              MyFlutterApp.home,
              MyFlutterApp.setup,
              MyFlutterApp.category,
              MyFlutterApp.brand
            ],
            onTap: (index) {
              Vibrate.vibrate();
              Provider.of<NavigationProvider>(context, listen: false)
                  .setSelectedItemPos(index);
            },
            activeColor: Provider.of<Uicolor>(context).defaultAccentColor,
            inactiveColor: Provider.of<DarkThemeProvider>(context).amoledTheme
                ? Uicolor.whiteColor
                : Theme.of(context).primaryColor,
            backgroundColor: Provider.of<DarkThemeProvider>(context).amoledTheme
                ? Uicolor.blackColor
                : Theme.of(context).primaryColorLight,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            leftCornerRadius: 25,
            rightCornerRadius: 25,
            splashColor: Provider.of<Uicolor>(context)
                .defaultAccentColor
                .withOpacity(0.5),
            activeIndex: Provider.of<NavigationProvider>(context, listen: true)
                .getSelectedItemPos(),
          ),
        ));
  }
}
