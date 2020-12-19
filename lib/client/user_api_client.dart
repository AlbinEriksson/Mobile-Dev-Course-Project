import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

enum UserAPIResult {
  success,
  invalidCredentials,
  clientError,
  roleNotFound,
  emailInUse,
  serverError,
  noRefreshToken,
  refreshTokenExpired,
  unknown,
}

class UserAPIClient {
  // This address (10.0.2.2) will connect to your PC's localhost, as opposed to
  // the localhost of the android emulator (since it is a virtual machine)
  //
  // For testing on a physical device, change this to the local IP of the
  // user API server host (e.g. 192.168.1.42). Make sure these are connected on
  // the same network!
  //
  // For the release build, modify this to the URL of the deployed user API.
  static const _apiUrl = "https://10.0.2.2";
  static const _clientLoginId = "android_app_login";

  UserAPIClient._(); // Prevent instantiation of this class

  static String _accessToken;
  static String _refreshToken;
  static String _userScope;

  /// Logs in a user. The access token, refresh token and scope will be stored
  /// statically in the UserAPIClient class, and cached accordingly.
  /// Possible result types (see enum UserAPIResult):
  /// - clientError
  /// - invalidCredentials
  /// - success
  /// - unknown
  static Future<UserAPIResult> login(String email, String password) {
    return http
        .post("$_apiUrl/token.php",
            headers: {"Content-Type": "application/json"},
            body: json.encode({
              "client_id": _clientLoginId,
              "password": password,
              "username": email,
              "grant_type": "password",
            }))
        .then((response) {
      switch (response.statusCode) {
        case 400:
          log("[ERROR] User API Client failed to make a proper request to login the user:");
          log(response.body);
          return UserAPIResult.clientError;
        case 401:
          return UserAPIResult.invalidCredentials;
        case 200:
          var body = json.decode(response.body);
          _accessToken = body["access_token"];
          _refreshToken = body["refresh_token"];
          _userScope = body["scope"];
          return UserAPIResult.success;
        default:
          log("[WARNING] User API Client, unknown status code for login: ${response.statusCode}");
          return UserAPIResult.unknown;
      }
    });
  }

  /// Registers a user. Note that this procedure does not login the user
  /// automatically. If you want the user to be logged in right after
  /// registration, call UserAPIClient.login(...) after this succeeds.
  /// Possible result types (see enum UserAPIResult):
  /// - clientError
  /// - roleNotFound
  /// - emailInUse
  /// - success
  /// - unknown
  /// - serverError
  static Future<UserAPIResult> register(String email, String password,
      String firstName, String lastName, String role) {
    if (lastName != null && lastName.trim().isEmpty) {
      lastName = null;
    }
    return http
        .post("$_apiUrl/register.php",
            headers: {"Content-Type": "application/json"},
            body: json.encode({
              "role": role,
              "lastName": lastName,
              "firstName": firstName,
              "password": password,
              "email": email,
            }))
        .then((response) {
      switch (response.statusCode) {
        case 400:
          log("[ERROR] User API Client failed to make a proper request to register the user:");
          log(response.body);
          return UserAPIResult.clientError;
        case 404:
          return UserAPIResult.roleNotFound;
        case 409:
          return UserAPIResult.emailInUse;
        case 500:
          return UserAPIResult.serverError;
        case 201:
          return UserAPIResult.success;
        default:
          log("[WARNING] User API Client, unknown status code for registration: ${response.statusCode}");
          return UserAPIResult.unknown;
      }
    });
  }

  /// Refreshes the access token by providing a refresh token to the API.
  /// The new access token, refresh token and scope will be stored statically
  /// in the UserAPIClient class, and cached accordingly.
  /// Possible result types (see enum UserAPIResult):
  /// - clientError
  /// - refreshTokenExpired
  /// - success
  /// - unknown
  static Future<UserAPIResult> refresh() {
    if(_refreshToken == null || _refreshToken.isEmpty) {
      return Future.value(UserAPIResult.noRefreshToken);
    }
    return http
        .post("$_apiUrl/token.php",
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "client_id": _clientLoginId,
          "refresh_token": _refreshToken,
          "grant_type": "refresh_token",
        }))
        .then((response) {
      switch (response.statusCode) {
        case 400:
          var body = json.decode(response.body);
          if(body["error"] == "invalid_grant") {
            return UserAPIResult.refreshTokenExpired;
          }
          log("[ERROR] User API Client failed to make a proper request to refresh the access token:");
          log(response.body);
          return UserAPIResult.clientError;
        case 200:
          var body = json.decode(response.body);
          _accessToken = body["access_token"];
          _refreshToken = body["refresh_token"];
          _userScope = body["scope"];
          return UserAPIResult.success;
        default:
          log("[WARNING] User API Client, unknown status code for login: ${response.statusCode}");
          return UserAPIResult.unknown;
      }
    });
  }
}
