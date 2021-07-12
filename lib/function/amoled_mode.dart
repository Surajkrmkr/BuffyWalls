import 'package:buffywalls/function/persistence.dart';
import 'package:buffywalls/navigation.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/app_details.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';

bool isAmoled = DarkModePersistenceService().savedAmoledMode();

class AmoledTile extends StatefulWidget {
  AmoledTile({this.navigationController});
  final NavigationController? navigationController;
  @override
  _AmoledTileState createState() => _AmoledTileState();
}

class _AmoledTileState extends State<AmoledTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        MyFlutterApp.amoled,
        color: isAmoled ? Uicolor.whiteColor : Get.theme.primaryColor,
        size: 25,
      ),
      onTap: () {
        if (!ProDialog.appIsPro) {
          ProDialog().getProDialog();
        } else {
          setState(() {
            if (isAmoled) {
              isAmoled = !isAmoled;
            } else {
              isAmoled = !isAmoled;
            }
            Phoenix.rebirth(context);
            widget.navigationController!.changeIndex(0);
            DarkModePersistenceService().saveAmoledMode(isAmoled);
          });
        }
      },
      trailing: ProDialog.appIsPro
          ? Switch(
              value: isAmoled,
              onChanged: (i) {
                setState(() {
                  isAmoled = i;
                  DarkModePersistenceService().saveAmoledMode(i);
                });
                Phoenix.rebirth(context);
                widget.navigationController!.changeIndex(0);
              },
            )
          : IconButton(
              icon: Icon(Typicons.lock_filled,color: Get.theme.primaryColor,),
              onPressed: () => ProDialog().getProDialog()),
      title: Text(
        'Amoled',
        style: MyTextStyle.bodyTextStyleWithDefaultSize(),
      ),
      // subtitle: Text(
      //   'Turn the Amoled theme on or off',
      //   style: MyTextStyle.bodyTextStyleWithDefaultSize(),
      // ),
    );
  }
}
