import 'dart:io';

import 'package:dva232_project/app.dart';
import 'package:dva232_project/client/languide_http_overrides.dart';
import 'package:dva232_project/settings.dart';
import 'package:flutter/material.dart';

void main() async {
  // Disable bad certificates if the user API has a valid certificate
  // (Currently, the user API is running on a local machine, without a valid
  // SSL certificate).
  HttpOverrides.global = LanGuideHttpOverrides(allowBadCertificates: true);

  // Wait for settings cache file to load, we need it to check the user's
  // locale before any UI is built.
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init();

  runApp(App());
}
