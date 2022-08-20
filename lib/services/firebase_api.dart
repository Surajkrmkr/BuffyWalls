import 'dart:io';
import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file,
      FirebaseStorage storage, BuildContext context) {
    try {
      var output = storage
          .ref()
          .child('$destination/${getBaseName(file.path)}')
          .putFile(file);
      return output;
    } on Exception {
      MySnackBar.wallSnackBar(context, "Failed to upload image");
      return null;
    }
  }

  static getBaseName(String path) {
    return path.split("/").last;
  }
}
