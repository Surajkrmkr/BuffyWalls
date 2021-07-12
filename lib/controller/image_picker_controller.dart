
import 'package:buffywalls/widgets/snack_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController{
  var setupImageLink = ''.obs;
  var firebaseSetupImageLink = ''.obs;
  imgFromGallery() async {
  try {
    final ImagePicker? picker = ImagePicker();
    PickedFile? image = await picker!.getImage(source: ImageSource.gallery);
      setupImageLink.value = image!.path;
  } on Exception catch (e) {
    print(e);
    getSnackbar('Something', 'went wrong');
  }
  
}
}