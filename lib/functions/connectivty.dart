import 'package:buffywalls_3/widgets/snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MyConnectivity {
  static checkConnectivity(context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      MySnackBar.getSnackBar(context, "No Internet Connection");
    }
  }
}
