import 'dart:io';

import 'package:buffywalls/api/firebase_api.dart';
import 'package:buffywalls/controller/image_picker_controller.dart';
import 'package:buffywalls/function/accent_color.dart';
import 'package:buffywalls/function/amoled_mode.dart';
import 'package:buffywalls/function/submit_form.dart';
import 'package:buffywalls/home.dart';
import 'package:buffywalls/theme/my_flutter_app_icons.dart';
import 'package:buffywalls/theme/ui_color.dart';
import 'package:buffywalls/widgets/loading_widget.dart';
import 'package:buffywalls/widgets/pro_dialog.dart';
import 'package:buffywalls/widgets/snack_bar.dart';
import 'package:buffywalls/widgets/text_style.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';

// submitForm(
//               authorController,
//               authorLinkController,
//               imageController,
//               imageLinkController,
//               kwgtController,
//               kwgtLinkController,
//               launcherController,
//               launcherLinkController,
//               iconpackController,
//               iconpackLinkController,
//               nameController),

class FinalSubmitPage extends StatelessWidget {
  FinalSubmitPage(
      {this.authorController,
      this.authorLinkController,
      this.imageController,
      this.imageLinkController,
      this.kwgtController,
      this.kwgtLinkController,
      this.launcherController,
      this.launcherLinkController,
      this.iconpackController,
      this.iconpackLinkController,
      this.nameController});

  final ImagePickerController imagePickerController = Get.find();

  UploadTask? task;

  final TextEditingController? authorController;
  final TextEditingController? authorLinkController;
  final TextEditingController? imageController;
  final TextEditingController? imageLinkController;
  final TextEditingController? kwgtController;
  final TextEditingController? kwgtLinkController;
  final TextEditingController? launcherController;
  final TextEditingController? launcherLinkController;
  final TextEditingController? nameController;
  final TextEditingController? iconpackController;
  final TextEditingController? iconpackLinkController;

  uploadImage(String? fileName) async {
    String destination = authorController!.text;
    print(fileName);
    final storage = FirebaseStorage.instance;
    task = FirebaseApi.uploadFile(destination, File(fileName!), storage);
    if (task == null) return null;
    Get.defaultDialog(
      barrierDismissible: false,
      onWillPop: () async => false,
      title: 'Uploading Data',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [loadingWidget2(), Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Text('Please wait'),
        )],
      ),
      titleStyle: MyTextStyle.bodyTextStyleWithDefaultSize(),
      backgroundColor:
          isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
    );
    final snapshot = await task!.whenComplete(() {});
    imagePickerController.firebaseSetupImageLink.value =
        await snapshot.ref.getDownloadURL();
    Navigator.of(Get.context!).popUntil((route) => route.isFirst);
    imagePickerController.setupImageLink.value = '';
    submitForm(
        authorController,
        authorLinkController,
        imageController,
        imageLinkController,
        kwgtController,
        kwgtLinkController,
        launcherController,
        launcherLinkController,
        iconpackController,
        iconpackLinkController,
        nameController,
        imagePickerController.firebaseSetupImageLink.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isAmoled ? Uicolor.blackColor : Get.theme.backgroundColor,
      body: Container(
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
                            'Add Setup Image',
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Obx(() {
                        return Center(
                          child: imagePickerController.setupImageLink.value ==
                                  ''
                              ? Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: isAmoled
                                          ? Uicolor.whiteColor.withOpacity(0.3)
                                          : Uicolor.blackColor.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: IconButton(
                                    icon: Icon(MyFlutterApp.add,
                                        size: 60, color: Uicolor.whiteColor),
                                    onPressed: () =>
                                        imagePickerController.imgFromGallery(),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.file(
                                    File(imagePickerController
                                        .setupImageLink.value),
                                  ),
                                ),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            if (imagePickerController.setupImageLink.value ==
                                '') {
                              getSnackbar('Add', 'Image first');
                            } else {
                              imagePickerController.imgFromGallery();
                            }
                          },
                          child: Text(
                            'Edit',
                            style: MyTextStyle.bodyTextStyle(
                                size: 14, color: defaultAccentColor),
                          ),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    defaultAccentColor)),
                            onPressed: () {
                              if (imagePickerController.setupImageLink.value ==
                                  '') {
                                getSnackbar('Add', 'Image first');
                              } else {
                                uploadImage(
                                    imagePickerController.setupImageLink.value);
                              }
                            },
                            child: Text('Submit',
                                style:
                                    MyTextStyle.bodyTextStyleWithDefaultSize()))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
