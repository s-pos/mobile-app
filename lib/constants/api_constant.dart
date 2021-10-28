class ApiConstant {
  ApiConstant._();

  static const String dev = "dev";
  static const String appDev = "SPOS Dev";
  static const String baseUrlDev = "https://api-dev.brinvestyuk.com";

  static const String prod = "Production";
  static const String appProd = "SPOS";
  static const String baseUrlProd = "https://api.spos.id";

  static const String errGlobal =
      "Terjadi kesalahan pada Server, silahkan coba beberapa saat lagi";
  static const String errCancel = "Permintaan data ke Server telah dibatalkan";
  static const String errConnectionTimeout =
      "Server sedang sibuk, silahkan coba beberapa saat lagi";
  static const String errReceivedTimeout =
      "Server sedang sibuk, silahkan coba beberapa saat lagi";
  static const String errSendTimeout =
      "Server sedang sibuk, silahkan coba beberapa saat lagi";

  static const int connectionTimeout = 30000;
  static const int receivedTimeout = 30000;
}
