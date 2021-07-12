import 'package:buffywalls/api/setup_submit_model.dart';
import 'package:buffywalls/controller/image_picker_controller.dart';
import 'package:buffywalls/controller/setup_submit_controller.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/function/submit_form.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'subpages/final_submit_page.dart';

class SubmitPage extends StatefulWidget {
  @override
  _MySubmitPage createState() => _MySubmitPage();
}

class _MySubmitPage extends State<SubmitPage> {
  final formKey = GlobalKey<FormState>();

  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());

  // TextField Controllers
  TextEditingController authorController = TextEditingController();
  TextEditingController authorLinkController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController imageLinkController = TextEditingController();
  TextEditingController kwgtController = TextEditingController();
  TextEditingController kwgtLinkController = TextEditingController();
  TextEditingController launcherController = TextEditingController();
  TextEditingController launcherLinkController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController iconpackController = TextEditingController();
  TextEditingController iconpackLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.navigate_next),
          backgroundColor: defaultAccentColor,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Get.to(FinalSubmitPage(
                  authorController: authorController,
                  authorLinkController: authorLinkController,
                  imageController: imageController,
                  imageLinkController: imageLinkController,
                  kwgtController: kwgtController,
                  kwgtLinkController: kwgtLinkController,
                  launcherController: launcherController,
                  launcherLinkController: launcherLinkController,
                  iconpackController: iconpackController,
                  iconpackLinkController: iconpackLinkController,
                  nameController: nameController));
            }
          },
          label: Text('Next')),
      backgroundColor:
          isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
      body: DoubleBack(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isAmoled
                        ? [Uicolor.blackColor, Uicolor.blackColor]
                        : Get.isDarkMode
                            ? [
                                Get.theme.backgroundColor,
                                Get.theme.backgroundColor
                              ]
                            : Uicolor.bgGradient)),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, bottom: 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Submit',
                              style: MyTextStyle.headerTextStyle(),
                            ),
                            !ProDialog.appIsPro
                                ? IconButton(
                                    padding: EdgeInsets.only(bottom: 5),
                                    iconSize: 35,
                                    splashColor:
                                        defaultAccentColor.withOpacity(0.3),
                                    icon: Icon(
                                      Typicons.infinity,
                                      color: defaultAccentColor,
                                    ),
                                    onPressed: () {
                                      ProDialog().getProDialog();
                                    })
                                : Container(),
                          ]),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Send us your cool setups to get feature in our app.',
                              style: MyTextStyle.bodyTextStyle(size: 18),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style:
                                          MyTextStyle.bodyTextStyle(size: 21),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SubmitTextField(
                                      nameController: authorController,
                                      hintName: 'Submited by',
                                      isOptional: false,
                                    ),
                                    SubmitTextField(
                                      nameController: nameController,
                                      hintName: 'Setup',
                                      isOptional: false,
                                    ),
                                    SubmitTextField(
                                      nameController: imageController,
                                      hintName: 'Wallpaper',
                                      isOptional: false,
                                    ),
                                    SubmitTextField(
                                      nameController: kwgtController,
                                      hintName: 'Kwgt Widget',
                                      isOptional: false,
                                    ),
                                    SubmitTextField(
                                      nameController: launcherController,
                                      hintName: 'Launcher',
                                      isOptional: false,
                                    ),
                                    SubmitTextField(
                                      nameController: iconpackController,
                                      hintName: 'Iconpack (optional)',
                                      isOptional: true,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Links (Optional)',
                                      style:
                                          MyTextStyle.bodyTextStyle(size: 21),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SubmitTextField(
                                      nameController: authorLinkController,
                                      hintName: 'Any Social ',
                                      isOptional: true,
                                    ),
                                    SubmitTextField(
                                      nameController: imageLinkController,
                                      hintName: 'Wallpaper / App ',
                                      isOptional: true,
                                    ),
                                    SubmitTextField(
                                      nameController: kwgtLinkController,
                                      hintName: 'Kwgt Widget',
                                      isOptional: true,
                                    ),
                                    SubmitTextField(
                                      nameController: launcherLinkController,
                                      hintName: 'Play store link',
                                      isOptional: true,
                                    ),
                                    SubmitTextField(
                                      nameController: iconpackLinkController,
                                      hintName: 'Iconpack',
                                      isOptional: true,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class SubmitTextField extends StatelessWidget {
  const SubmitTextField(
      {Key? key,
      required this.nameController,
      required this.hintName,
      this.isOptional})
      : super(key: key);

  final TextEditingController nameController;
  final String? hintName;
  final bool? isOptional;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (!isOptional!) {
            if (value!.isEmpty) {
              return 'Enter value here';
            }
          }
          return null;
        },
        style: MyTextStyle.bodyTextStyleWithDefaultSize(),
        decoration: InputDecoration(
          labelText: hintName!,
          labelStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: defaultAccentColor, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isAmoled
                    ? Uicolor.whiteColor
                    : Get.isDarkMode
                        ? Uicolor.whiteColor
                        : Uicolor.blackColor.withOpacity(0.7),
                width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: defaultAccentColor, width: 3.0),
          ),
        ),
      ),
    );
  }
}
