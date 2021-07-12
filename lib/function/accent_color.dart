import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/function/persistence.dart';
import 'package:buffywalls/navigation.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';

Color defaultAccentColor =
    Color(DarkModePersistenceService().savedAccentColor());

class AccentColorPickerTile extends StatefulWidget {
  AccentColorPickerTile({this.navigationController});
  final NavigationController? navigationController;
  final Color tempAccentColor = defaultAccentColor;
  @override
  _AccentColorPickerTileState createState() => _AccentColorPickerTileState();
}

class _AccentColorPickerTileState extends State<AccentColorPickerTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        MyFlutterApp.color,
        color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
        size: 25,
      ),
      onTap: () {
        ProDialog.appIsPro ? accentColorDialog() : ProDialog().getProDialog();
      },
      trailing: ProDialog.appIsPro
          ? Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Container()
              // CircleColor(color: defaultAccentColor, circleSize: 30),
            )
          : IconButton(
              icon: Icon(Typicons.lock_filled, color: Get.theme.primaryColor),
              onPressed: () => ProDialog().getProDialog()),
      title: Text(
        'Accent Color',
        style: MyTextStyle.bodyTextStyleWithDefaultSize(),
      ),
      // subtitle: Text(
      //   'Choose favourite accent color',
      //   style: MyTextStyle.bodyTextStyleWithDefaultSize(),
      // ),
    );
  }

  Future accentColorDialog() {
    return Get.defaultDialog(
      title: 'Choose Color',
      titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
      backgroundColor:
          isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFFE5C6D))),
            onPressed: () {
              setState(() {
                defaultAccentColor = Color(0xFFFE5C6D);
                Phoenix.rebirth(context);
                widget.navigationController!.changeIndex(0);
                DarkModePersistenceService()
                    .saveAccentColor(defaultAccentColor.value);
              });
            },
            child: Text('Default',
                style: MyTextStyle.bodyTextStyle(
                    size: 14, color: Uicolor.whiteColor))),
        OutlinedButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Cancel',
            style:
                MyTextStyle.bodyTextStyle(size: 14, color: defaultAccentColor),
          ),
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(defaultAccentColor)),
            onPressed: () {
              defaultAccentColor = widget.tempAccentColor;
              Phoenix.rebirth(context);
              widget.navigationController!.changeIndex(0);
              DarkModePersistenceService()
                  .saveAccentColor(widget.tempAccentColor.value);
            },
            child: Text('Set',
                style: MyTextStyle.bodyTextStyle(
                    size: 14, color: Uicolor.whiteColor))),
      ],
      // content: Container(
      //   height: 180,
      //   child: MaterialColorPicker(
      //     spacing: 10,
      //     allowShades: true,
      //     circleSize: 50,
      //     selectedColor: defaultAccentColor,
      //     shrinkWrap: true,
      //     onColorChange: (color) {
      //       setState(() {
      //         widget.tempAccentColor = color;
      //       });
      //     },
      //     colors: accentColors,
      //   ),
      // ),
    );
  }
}
