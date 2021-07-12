import 'dart:io';
import 'package:path/path.dart';
import 'package:buffywalls/widgets/snack_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi{
  static UploadTask? uploadFile(String destination,File file,FirebaseStorage storage) {
    try {
      var output = storage.ref().child('$destination/${basename(file.path)}').putFile(file);
      return output;
    } on Exception catch (e) {
      print(e);
      getSnackbar("Failed", "to upload image");
      return null;
    }
  }
}