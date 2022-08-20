import 'dart:io';

import 'package:buffywalls_3/provider/setup.dart';
import 'package:buffywalls_3/provider/submit_setup.dart';
import 'package:buffywalls_3/theme/dark_theme.dart';
import 'package:buffywalls_3/theme/ui_color.dart';
import 'package:buffywalls_3/widgets/scaffold.dart';
import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/my_flutter_app_icons.dart';
import '../widgets/text_style.dart';

class SubmitPage extends StatelessWidget {
  SubmitPage({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MyScaffold.getStaggeredScaffold(
      context: context,
      header: "Submit Setup",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<SetupSubmitProvider>(
                  builder: (context, setupProvider, _) {
                return Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: setupProvider.setupImageLink.isEmpty
                                ? Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Provider.of<DarkThemeProvider>(
                                                      context,
                                                      listen: false)
                                                  .amoledTheme
                                              ? Uicolor.whiteColor
                                              : Provider.of<DarkThemeProvider>(
                                                          context)
                                                      .darkTheme
                                                  ? Uicolor.whiteColor
                                                  : Uicolor.blackColor
                                                      .withOpacity(0.6),
                                        ),
                                        color: Provider.of<DarkThemeProvider>(
                                                    context,
                                                    listen: false)
                                                .amoledTheme
                                            ? Uicolor.blackColor
                                            : Theme.of(context)
                                                .primaryColorLight,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: IconButton(
                                      icon: Icon(MyFlutterApp.imageadd,
                                          size: 40,
                                          color: Provider.of<DarkThemeProvider>(
                                                      context,
                                                      listen: false)
                                                  .amoledTheme
                                              ? Uicolor.whiteColor
                                              : Theme.of(context).primaryColor),
                                      onPressed: () =>
                                          setupProvider.imgFromGallery(),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.file(
                                            File(setupProvider.setupImageLink),
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0, bottom: 15),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                onPressed: () {
                                                  setupProvider
                                                      .imgFromGallery();
                                                },
                                                icon: const Icon(Icons.edit),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          SubmitTextField(
                            nameController: setupProvider.nameController,
                            hintName: 'Setup Name',
                            iconData: MyFlutterApp.setup,
                            isOptional: false,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                'Name',
                                style: MyTextStyle.bodyTextStyle(
                                    context: context, size: 21),
                              ),
                              const Spacer(),
                              Text(
                                'Links(Optional)',
                                style: MyTextStyle.bodyTextStyle(
                                    context: context, size: 21),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SubmitTextField(
                                  nameController:
                                      setupProvider.authorController,
                                  hintName: 'Your Name',
                                  iconData: MyFlutterApp.user,
                                  isOptional: false,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: SubmitTextField(
                                  nameController:
                                      setupProvider.authorLinkController,
                                  hintName: "Social Link",
                                  iconData: Icons.link,
                                  isOptional: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SubmitTextField(
                                  nameController: setupProvider.imageController,
                                  hintName: 'Wallpaper',
                                  iconData: MyFlutterApp.wall,
                                  isOptional: false,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: SubmitTextField(
                                  nameController:
                                      setupProvider.imageLinkController,
                                  hintName: 'Wall App Link',
                                  iconData: Icons.link,
                                  isOptional: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SubmitTextField(
                                  nameController: setupProvider.kwgtController,
                                  hintName: 'Kwgt',
                                  iconData: Icons.label_important,
                                  isOptional: false,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: SubmitTextField(
                                  nameController:
                                      setupProvider.kwgtLinkController,
                                  iconData: Icons.link,
                                  hintName: 'Kwgt App Link',
                                  isOptional: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SubmitTextField(
                                  nameController:
                                      setupProvider.iconpackController,
                                  hintName: 'Iconpack',
                                  iconData: Icons.android,
                                  isOptional: false,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: SubmitTextField(
                                  iconData: Icons.link,
                                  nameController:
                                      setupProvider.iconpackLinkController,
                                  hintName: 'Icon App Link',
                                  isOptional: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Select Launcher !';
                              }
                              return null;
                            },
                            borderRadius: BorderRadius.circular(15),
                            dropdownColor: Provider.of<DarkThemeProvider>(
                                        context,
                                        listen: false)
                                    .amoledTheme
                                ? Uicolor.blackColor
                                : Theme.of(context).backgroundColor,
                            hint: Text(
                              'Launcher',
                              style: MyTextStyle.bodyTextStyleWithDefaultSize(
                                  context: context),
                            ),
                            items: SetupProvider.launcherList.entries
                                .map((MapEntry ele) => DropdownMenuItem(
                                    value: ele.key,
                                    child: Text(
                                      ele.key,
                                      style: MyTextStyle
                                          .bodyTextStyleWithDefaultSize(
                                              context: context),
                                    )))
                                .toList(),
                            onChanged: (launcher) {
                              setupProvider.launcherLinkController.text =
                                  SetupProvider.launcherList[launcher]
                                      .toString();
                              setupProvider.launcherController.text =
                                  launcher.toString();
                            },
                            decoration: InputDecoration(
                              labelStyle:
                                  MyTextStyle.bodyTextStyleWithDefaultSize(
                                      context: context),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Provider.of<Uicolor>(context)
                                        .defaultAccentColor,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Provider.of<DarkThemeProvider>(
                                                context,
                                                listen: false)
                                            .amoledTheme
                                        ? Uicolor.whiteColor
                                        : Provider.of<DarkThemeProvider>(
                                                    context)
                                                .darkTheme
                                            ? Uicolor.whiteColor
                                            : Uicolor.blackColor
                                                .withOpacity(0.6),
                                    width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Provider.of<Uicolor>(context)
                                        .defaultAccentColor,
                                    width: 3.0),
                              ),
                            ),
                          )
                        ]));
              }),
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (Provider.of<SetupSubmitProvider>(context,
                                  listen: false)
                              .setupImageLink
                              .isNotEmpty) {
                            Provider.of<SetupSubmitProvider>(context,
                                    listen: false)
                                .uploadImage(context);
                          } else {
                            MySnackBar.wallSnackBar(
                                context, "Please Select Setup Screenshot");
                          }
                        }
                      },
                      child: Text(
                        'Submit',
                        style: MyTextStyle.bodyTextStyle(
                            context: context,
                            size: 16,
                            color: Uicolor.whiteColor),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmitTextField extends StatelessWidget {
  const SubmitTextField(
      {Key? key,
      required this.nameController,
      required this.hintName,
      required this.iconData,
      this.isOptional})
      : super(key: key);

  final TextEditingController nameController;
  final String hintName;
  final IconData iconData;
  final bool? isOptional;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        cursorColor: Provider.of<Uicolor>(context).defaultAccentColor,
        controller: nameController,
        validator: (value) {
          if (!isOptional!) {
            if (value!.isEmpty) {
              return 'Oops Missing Data!';
            }
          }
          return null;
        },
        style: MyTextStyle.bodyTextStyleWithDefaultSize(context: context),
        decoration: InputDecoration(
          label: isOptional!
              ? Icon(
                  iconData,
                  color: Provider.of<DarkThemeProvider>(context, listen: false)
                          .amoledTheme
                      ? Uicolor.whiteColor
                      : Theme.of(context).primaryColor,
                )
              : Row(
                  children: [
                    Icon(
                      iconData,
                      color:
                          Provider.of<DarkThemeProvider>(context, listen: false)
                                  .amoledTheme
                              ? Uicolor.whiteColor
                              : Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      hintName,
                      style: MyTextStyle.bodyTextStyleWithDefaultSize(
                          context: context),
                    ),
                  ],
                ),
          floatingLabelStyle: MyTextStyle.bodyTextStyle(
              context: context,
              size: 15,
              color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Provider.of<Uicolor>(context).defaultAccentColor,
                width: 1.0),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Provider.of<DarkThemeProvider>(context, listen: false)
                        .amoledTheme
                    ? Uicolor.whiteColor
                    : Provider.of<DarkThemeProvider>(context).darkTheme
                        ? Uicolor.whiteColor
                        : Uicolor.blackColor.withOpacity(0.6),
                width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Provider.of<Uicolor>(context).defaultAccentColor,
                width: 3.0),
          ),
        ),
      ),
    );
  }
}
