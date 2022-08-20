import 'package:flutter/foundation.dart';

class AdmobUnitID {
  static String? bannerUnitID = 'ca-app-pub-4861691653340010/8634209589';
  static String? interstitialUnitID = 'ca-app-pub-4861691653340010/1358354795';
  static String? nativeUnitID = 'ca-app-pub-4861691653340010/6937984537';

  static String? get getBannerID {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      return bannerUnitID;
    }
  }

  static String? get getInterstitialID {
    if (kDebugMode) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      return interstitialUnitID;
    }
  }

  static String? get getNativeID {
    if (kDebugMode) {
      return "ca-app-pub-3940256099942544/2247696110";
    } else {
      return nativeUnitID;
    }
  }
}
