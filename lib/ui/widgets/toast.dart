import '../../app/app.package.export.dart';
import '../common/common_export.dart';

void showToast(String msg) => Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundDark,
    textColor: backgroundLight,
    fontSize: 16.0);
