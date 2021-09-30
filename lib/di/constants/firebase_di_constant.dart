class FirebaseDiConstant {
  FirebaseDiConstant._();

  static const Duration fetchTimeoutDuration = Duration(seconds: 10);
  static const Duration minimumFetchInterval = Duration(hours: 2);

  // Firebase dynamic links for development (staging)
  static const String prefixDev = "https://devspos.page.link";
  static const String urlDev = "https://dev.spos.id";
  // Firebase dynamic links for production
  static const String prefixProd = "https://spos.lin";
  static const String urlProd = "https://www.spos.id";
}
