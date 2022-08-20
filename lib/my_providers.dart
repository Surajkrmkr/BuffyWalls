import 'package:buffywalls_3/functions/app_details.dart';
import 'package:buffywalls_3/provider/category_brand.dart';
import 'package:buffywalls_3/provider/category_brand_wall.dart';
import 'package:buffywalls_3/provider/download_wall.dart';
import 'package:buffywalls_3/provider/favourite.dart';
import 'package:buffywalls_3/provider/image_view.dart';
import 'package:buffywalls_3/provider/setup.dart';
import 'package:buffywalls_3/provider/submit_setup.dart';
import 'package:buffywalls_3/provider/trending_popular.dart';
import 'package:buffywalls_3/theme/ui_color.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'provider/color_palette.dart';
import 'provider/navigation.dart';
import 'theme/dark_theme.dart';

class MyProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
    ChangeNotifierProvider(create: (_) => NavigationProvider()),
    ChangeNotifierProvider(create: (_) => PopularProvider()),
    ChangeNotifierProvider(create: (_) => TrendingProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => BrandProvider()),
    ChangeNotifierProvider(create: (_) => SetupProvider()),
    ChangeNotifierProvider(create: (_) => SetupSubmitProvider()),
    ChangeNotifierProvider(create: (_) => FeatureProvider()),
    ChangeNotifierProvider(create: (_) => CategorizedProvider()),
    ChangeNotifierProvider(create: (_) => ImageViewProvider()),
    ChangeNotifierProvider(create: (_) => PaletteGeneratorProvider()),
    ChangeNotifierProvider(create: (_) => DownloadWallProvider()),
    ChangeNotifierProvider(create: (_) => FavouriteProvider()),
    ChangeNotifierProvider(create: (_) => AppDetails()),
    ChangeNotifierProvider(create: (_) => Uicolor()),
  ];
}
