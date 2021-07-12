import 'dart:convert' as convert;
import 'package:buffywalls/api/setup_submit_model.dart';
import 'package:http/http.dart' as http;

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using 
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class SubmitFormController {
  
  // Google App Script Web URL.
  static const String URL = "https://script.google.com/macros/s/AKfycbxNdIOGRExS47ci9Qy0SJ8GXfetY3ur6c_MdSJDNCX85GC5JGhPX5iTUgkhZoo3dd5NFA/exec";
  
  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
   void submitForm(
      SubmitForm feedbackForm, void Function(String) callback) async {
    try {
      await http.post(Uri.parse(URL), body: feedbackForm.toJson()).then((response) async {
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
      print(e);
    }
  }
}