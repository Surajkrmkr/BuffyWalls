import 'package:buffywalls_3/functions/vibrate.dart';
import 'package:buffywalls_3/theme/ui_color.dart';
import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:buffywalls_3/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAccentColor {
  static getAccentColorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Accent Color",
                style:
                    MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
              ),
              content: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: Uicolor.accentColors
                    .map((e) => GestureDetector(
                          onTap: () {
                            Provider.of<Uicolor>(context, listen: false)
                                .defaultAccentColor = e;
                            Vibrate.vibrate();
                            Navigator.pop(context);
                            MySnackBar.wallSnackBar(
                                context, "Accent Color Changed");
                          },
                          child: CircleAvatar(
                            backgroundColor: e,
                          ),
                        ))
                    .toList(),
              ),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFFFE5C6D))),
                    onPressed: () {
                      Provider.of<Uicolor>(context, listen: false)
                          .defaultAccentColor = const Color(0xFFFE5C6D);
                      Vibrate.vibrate();
                      Navigator.pop(context);
                      MySnackBar.wallSnackBar(
                          context, "Accent Color Changed to default");
                    },
                    child: const Text(
                      "Default",
                    )),
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
