import 'package:buffywalls/api/setup_submit_model.dart';
import 'package:buffywalls/controller/setup_submit_controller.dart';
import 'package:buffywalls/widgets/snack_bar.dart';

void submitForm(
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
    setupImageLink) {
  // if (_formKey.currentState!.validate()) {
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
    setupImageLink,
  );

  SubmitFormController submitFormController = SubmitFormController();

  // _showSnackbar("Submitting Feedback");

  // Submit 'feedbackForm' and save it in Google Sheets.
  submitFormController.submitForm(submitForm, (String response) {
    print("Response: $response");
    if (response == SubmitFormController.STATUS_SUCCESS) {
      // Feedback is saved succesfully in Google Sheets.
      getSnackbar('Uploaded successfully', 'will be soon featured in app');
    } else {
      // // Error Occurred while saving data in Google Sheets.
      getSnackbar('Error', 'While uploading data');
    }
  });
}
  // }