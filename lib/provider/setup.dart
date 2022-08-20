import 'package:buffywalls_3/model/setup.dart';
import 'package:flutter/material.dart';
import '../services/setup.dart';

class SetupProvider extends ChangeNotifier {
  var isLoading = true;
  bool get getIsLoading => isLoading;
  set setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  List<Setup> imageList = [];
  SetupProvider() {
    fetchData();
  }

  Future fetchData() async {
    setIsLoading = true;
    try {
      var list = await SetupPageServices.fetchData();
      imageList = list.setup!;
      imageList.sort((a, b) =>
          int.parse(b.id.toString()).compareTo(int.parse(a.id.toString())));
    } on Exception catch (e) {
      throw Exception(e);
    } finally {
      setIsLoading = false;
    }
  }

  static final launcherList = {
    'Nova Launcher':
        'https://play.google.com/store/apps/details?id=com.teslacoilsw.launcher&hl=en_IN&gl=US',
    'OnePlus Launcher':
        'https://play.google.com/store/apps/details?id=net.oneplus.launcher&hl=en_IN&gl=US',
    'Microsoft Launcher':
        'https://play.google.com/store/apps/details?id=com.microsoft.launcher&hl=en_IN&gl=US',
    'Poco Launcher':
        'https://play.google.com/store/apps/details?id=com.mi.android.globallauncher&hl=en_IN&gl=US',
    'Lawnchair 2':
        'https://play.google.com/store/apps/details?id=ch.deletescape.lawnchair.plah&hl=en_IN&gl=US',
    'Smart Launcher':
        'https://play.google.com/store/apps/details?id=ginlemon.flowerfree&hl=en_IN&gl=US',
    'Niagara Launcher':
        'https://play.google.com/store/apps/details?id=bitpit.launcher&hl=en_IN&gl=US'
  };
}
