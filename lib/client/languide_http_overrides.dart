import 'dart:io';

class LanGuideHttpOverrides extends HttpOverrides {
  final bool allowBadCertificates;

  LanGuideHttpOverrides({this.allowBadCertificates});

  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}