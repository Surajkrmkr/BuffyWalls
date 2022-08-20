import 'package:buffywalls_3/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../model/setup_submit.dart';
import '../services/firebase_api.dart';
import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SetupSubmitProvider extends ChangeNotifier {
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

  //setup
  String _setupImageLink = '';
  String _firebaseSetupImageLink = '';

  String get setupImageLink => _setupImageLink;
  String get firebaseSetupImageLink => _firebaseSetupImageLink;

  set setupImageLink(String value) {
    _setupImageLink = value;
    notifyListeners();
  }

  set firebaseSetupImageLink(String value) {
    _firebaseSetupImageLink = value;
    notifyListeners();
  }

  imgFromGallery({BuildContext? context}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      setupImageLink = image!.path;
    } on Exception catch (e) {
      MySnackBar.wallSnackBar(context!, "Something went wrong");
      throw Exception(e);
    }
  }

  // Google App Script Web URL.
  static const String scriptUrl =
      "https://script.google.com/macros/s/AKfycbxNdIOGRExS47ci9Qy0SJ8GXfetY3ur6c_MdSJDNCX85GC5JGhPX5iTUgkhZoo3dd5NFA/exec";

  // Success Status Message
  static const statusSuccess = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void finalSubmit(
      SubmitForm feedbackForm, void Function(String) callback) async {
    try {
      await http
          .post(Uri.parse(scriptUrl), body: feedbackForm.toJson())
          .then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(Uri.parse(url!)).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  uploadImage(context) async {
    String destination = authorController.text;
    final storage = FirebaseStorage.instance;
    UploadTask? task = FirebaseApi.uploadFile(
        destination, File(setupImageLink), storage, context);
    if (task == null) return null;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Uploading Image"),
              content: Wrap(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 40, child: loadingWidget(context)),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: Text("Please wait while we upload your image."),
                      )
                    ],
                  )
                ],
              ),
            ));

    final snapshot = await task.whenComplete(() {});
    firebaseSetupImageLink = await snapshot.ref.getDownloadURL();
    SubmitForm submitForm = SubmitForm(
      authorController.text,
      authorLinkController.text,
      imageController.text,
      imageLinkController.text,
      kwgtController.text,
      kwgtLinkController.text,
      launcherController.text,
      launcherLinkController.text,
      iconpackController.text,
      iconpackLinkController.text,
      nameController.text,
      firebaseSetupImageLink,
    );

    finalSubmit(submitForm, (String response) {
      if (response == statusSuccess) {
        // Feedback is saved succesfully in Google Sheets.
        Navigator.pop(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Upload Successful"),
                  content: const Text(
                      "Thank you for your submission!\nWe will review and feature it on the app soon."),
                  actions: [
                    ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        setBackToNormal();
                      },
                    )
                  ],
                ));
      } else {
        // // Error Occurred while saving data in Google Sheets.
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Upload Failed"),
                  content: const Text(
                      "Something went wrong while uploading your submission. \n Please try again later."),
                  actions: [
                    ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        setBackToNormal();
                      },
                    )
                  ],
                ));
      }
    });
  }

  void setBackToNormal() {
    authorController.text = '';
    authorLinkController.text = '';
    imageController.text = '';
    imageLinkController.text = '';
    kwgtController.text = '';
    kwgtLinkController.text = '';
    launcherController.text = '';
    launcherLinkController.text = '';
    iconpackController.text = '';
    iconpackLinkController.text = '';
    nameController.text = '';
    setupImageLink = '';
    firebaseSetupImageLink = '';
  }
}
