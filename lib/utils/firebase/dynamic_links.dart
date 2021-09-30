import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinksUtil {
  FirebaseDynamicLinksUtil._();

  static Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (linkData) => _handleDynamicLink(linkData),
      onError: (error) async => print(error.message),
    );
  }

  // handle dynamic link
  // with path parameters and query (if there has it)
  static _handleDynamicLink(PendingDynamicLinkData? data) async {
    final Uri? deeplink = data?.link;

    if (deeplink == null) {
      return;
    }
    // check if path contains 'v' means 'Verification'
    // then it will be go to verification code
    if (deeplink.path.contains("v")) {
      String? token = deeplink.queryParameters["token"];
    }
  }
}
