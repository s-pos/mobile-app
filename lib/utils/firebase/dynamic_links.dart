import "dart:convert";
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/di/module/navigation_module.dart';
import 'package:spos/routes/routes.dart';

class FirebaseDynamicLinksUtil {
  FirebaseDynamicLinksUtil();

  final NavigationModule navigation = getIt<NavigationModule>();

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (linkData) => _handleDynamicLink(linkData),
      onError: (error) async => print(error.message),
    );
  }

  // handle dynamic link
  // with path parameters and query (if there has it)
  _handleDynamicLink(PendingDynamicLinkData? data) async {
    final Uri? deeplink = data?.link;

    if (deeplink == null) {
      return;
    }
    // check if path contains 'v' means 'Verification'
    // then it will be go to verification code
    if (deeplink.path.contains("v")) {
      // init base64 codec
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String? token = deeplink.queryParameters["token"]; // get from '?token='
      String? emailEncoded = deeplink.queryParameters["e"]; // get from '&e='
      // decode email url
      String? email =
          emailEncoded == null ? null : stringToBase64.decode(emailEncoded);
      final data = {
        "otp": token,
        "email": email,
      };

      navigation.navigateToAndRemove(Routes.verificationRegister,
          arguments: data);
    }
  }
}
