import 'dart:io';

import 'package:dva232_project/app.dart';
import 'package:dva232_project/client/languide_http_overrides.dart';
import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/settings.dart';
import 'package:flutter/material.dart';

void main() async {
  // Disable bad certificates if the user API has a valid certificate
  // (Currently, the user API is running on a local machine, without a valid
  // SSL certificate).
  HttpOverrides.global = LanGuideHttpOverrides(allowBadCertificates: true);

  // Needed to wait for local cache storage to load before UI is built.
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for settings cache file to load, we need it to check the user's
  // locale before any UI is built.
  await Settings.init();

  // Wait for user API client cache to load, since it contains the refresh token
  // which may be used to skip the front and login pages.
  await UserAPIClient.init();

  runApp(App());
}
