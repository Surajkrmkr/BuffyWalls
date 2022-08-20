import 'dart:convert';
import 'package:buffywalls_3/model/trending_popular.dart';
import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class FavouriteProvider extends ChangeNotifier {
  List<HomePageImage> _favouriteList =
      FavPersistenceService().getFavouriteList();
  // List<HomePageImage> _favouriteList = [];

  List<HomePageImage> get favouriteList => _favouriteList;
  set favouriteList(List<HomePageImage> val) {
    _favouriteList = val;
    notifyListeners();
  }

  addWallToFav(wall) {
    _favouriteList.add(wall);
    FavPersistenceService().saveFavouriteList(_favouriteList);
    notifyListeners();
  }

  deleteWallFromFav({BuildContext? context, int? index}) {
    _favouriteList.removeAt(index!);
    notifyListeners();
    FavPersistenceService().saveFavouriteList(_favouriteList);
    MySnackBar.wallSnackBar(context, 'Removed From Favourite');
  }

  addToFav({BuildContext? context, var imageData, String? category}) {
    bool canBeAdded = true;
    for (int i = 0; i < favouriteList.length; i++) {
      if (favouriteList[i].imageUrl == imageData!.imageUrl) {
        canBeAdded = false;
      }
    }

    final item = HomePageImage()
      ..id = imageData!.id
      ..downloads = imageData!.downloads
      ..name = imageData!.name
      ..category = category
      ..size = imageData.size
      ..designer = imageData.designer
      ..heroId = imageData.heroId
      ..isPremium = imageData.isPremium
      ..imageUrl = imageData.imageUrl
      ..compressUrl = imageData.compressUrl ?? imageData.imageUrl;

    if (canBeAdded) {
      addWallToFav(item);
      MySnackBar.wallSnackBar(context, 'Added to Favourite');
    } else {
      MySnackBar.wallSnackBar(context, 'Already in Favourite');
    }
  }
}

class FavPersistenceService {
  final getStorage = GetStorage();
  final favKey = "fav";

  List<HomePageImage> getFavouriteList() {
    Iterable l = json.decode(getStorage.read(favKey) ?? '[]');
    List<HomePageImage> imgs =
        List<HomePageImage>.from(l.map((img) => HomePageImage.fromJson(img)));
    return imgs;
  }

  void saveFavouriteList(List<HomePageImage> val) {
    getStorage.write(favKey, jsonEncode(val));
  }
}
