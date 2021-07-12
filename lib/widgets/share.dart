import 'package:buffywalls/widgets/app_details.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

shareImage(String url) async {
  try {
    WcFlutterShare.share(
        sharePopupTitle: 'Share this Awesome Image to Your Friends',
        subject: 'Hii Check Out this Awesome Wallpaper App',
        text: 'Check out This Awesome Wallpaper \n' +
            url +
            '\n Download This Cool App Link : '+ AppDetails.appUrl,
        mimeType: 'text/plain');
  } catch (e) {
    print(e);
  }
}

shareApp() async {
  try {
    WcFlutterShare.share(
        sharePopupTitle: 'Share this Awesome Wallpaper App to Your Friends',
        text:
            'Check out This Awesome Wallpaper App \n Link : ${AppDetails.appUrl}',
        mimeType: 'text/plain');
  } catch (e) {
    print(e);
  }
}
