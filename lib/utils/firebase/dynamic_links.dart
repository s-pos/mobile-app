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
      String? token = deeplink.queryParameters["token"];
      final data = {
        "tokenEmail": token,
      };

      navigation.navigateToAndRemove(Routes.verificationRegister,
          arguments: data);
    }
  }
}
