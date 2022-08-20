import 'package:buffywalls_3/functions/vibrate.dart';
import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MyCache {
  static getClearCacheDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Clear Cache",
                style:
                    MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
              ),
              content: Wrap(alignment: WrapAlignment.center, children: [
                Text(
                  "Are you sure you want to clear cache?",
                  style: MyTextStyle.bodyTextStyleWithDefaultSize(
                      context: context),
                ),
              ]),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      DefaultCacheManager().emptyCache();
                      Vibrate.vibrate();
                      Navigator.pop(context);
                      MySnackBar.wallSnackBar(
                          context, "Cache cleared successfully");
                    },
                    child: const Text("Clear")),
              ],
            ));
  }
}
