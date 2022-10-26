import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/pro_dialog.dart';
import '../widgets/text_style.dart';
import 'app_details.dart';

class MyUpdate {
  static statusCheck(context) async {
    // await Future.delayed(const Duration(seconds: 3));
    final newVersion = NewVersionPlus(
      androidId: ProDialog.appIsPro
          ? AppDetails.proPackageName
          : AppDetails.packageName,
    );
    final status = await newVersion.getVersionStatus();
    await Future.delayed(const Duration(seconds: 3));
    if (status!.canUpdate) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  'Update Available : ${status.storeVersion}',
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
                ),
                content: Text(
                  status.releaseNotes!,
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Later'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () {
                      ProDialog.appIsPro
                          ? launchUrl(Uri.parse(AppDetails.proAppUrl),
                              mode: LaunchMode.externalApplication)
                          : launchUrl(Uri.parse(AppDetails.appUrl),
                              mode: LaunchMode.externalApplication);
                    },
                  ),
                ],
              ));
    }
  }

// Future<void> checkPiracy(isPirated) async {
//   try {
//     isPirated = await getIsPirated(
//       debugOverride: true,
//       // openStoreListing: true,
//       // playStoreIdentifier: ProDialog.appIsPro ? AppDetails.proPackageName:AppDetails.packageName,
//       // closeApp: true,
//     );
//     if (isPirated.status!) {
//       Get.defaultDialog(
//           onWillPop: () async => false,
//           barrierDismissible: false,
//           title: 'Something went wrong',
//           middleText: 'Please reinstall the app from playstore',
//           titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
//           middleTextStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
//           backgroundColor:
//               isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
//           actions: [
//             OutlinedButton(
//               onPressed: () {
//                 SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//               },
//               child: Text(
//                 'Close',
//                 style: MyTextStyle.bodyTextStyle(
//                     size: 14, color: defaultAccentColor),
//               ),
//             ),
//             ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all(defaultAccentColor)),
//                 onPressed: () {
//                   ProDialog.appIsPro
//                       ? launch(AppDetails.proAppUrl)
//                       : launch(AppDetails.appUrl);
//                 },
//                 child: Text('Reinstall',
//                     style: MyTextStyle.bodyTextStyleWithDefaultSize()))
//           ]);
//     }
//   } on Exception catch (e) {
//     throw Exception(e);
//   }
// }

}
