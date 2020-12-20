import 'dart:developer';

import 'package:localstorage/localstorage.dart';
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
  accessTokenExpired,
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

  static final LocalStorage _storage = LocalStorage("user_api_client.json");
  static const String _storageRefreshTokenKey = "refresh_token";

  static void _setTokenData(
      String accessToken, String refreshToken, String userScope) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userScope = userScope;

    _storage.setItem(_storageRefreshTokenKey, _refreshToken);
  }

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
          _setTokenData(
              body["access_token"], body["refresh_token"], body["scope"]);
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
  /// - noRefreshToken
  /// - refreshTokenExpired
  /// - success
  /// - unknown
  static Future<UserAPIResult> refresh() {
    _refreshToken = _storage.getItem(_storageRefreshTokenKey);
    if (_refreshToken == null || _refreshToken.isEmpty) {
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
          if (body["error"] == "invalid_grant") {
            return UserAPIResult.refreshTokenExpired;
          }
          log("[ERROR] User API Client failed to make a proper request to refresh the access token:");
          log(response.body);
          return UserAPIResult.clientError;
        case 200:
          var body = json.decode(response.body);
          _setTokenData(
              body["access_token"], body["refresh_token"], body["scope"]);
          return UserAPIResult.success;
        default:
          log("[WARNING] User API Client, unknown status code for login: ${response.statusCode}");
          return UserAPIResult.unknown;
      }
    });
  }

  /// Submits a test result. Uses the internally stored access token, so there's
  /// no need to provide it as an argument for this method.
  /// Possible result types (see enum UserAPIResult):
  /// - serverError
  /// - clientError
  /// - accessTokenExpired (it will try to refresh it <b>once</b> before
  /// returning this result).
  /// - noRefreshToken
  /// - refreshTokenExpired
  /// - success
  /// - unknown
  static Future<UserAPIResult> submitTestResults(
      String testType, String difficulty, double accuracy) {
    _tryMethod(() {
      return http
          .post("$_apiUrl/results.php",
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $_accessToken"
              },
              body: json.encode({
                "difficulty": difficulty,
                "type": testType,
                "accuracy": accuracy
              }))
          .then((response) {
        switch (response.statusCode) {
          case 500:
            return UserAPIResult.serverError;
          case 400:
          case 404:
            log("[ERROR] User API Client failed to make a proper request to submit test results:");
            log(response.body);
            return UserAPIResult.clientError;
          case 401:
            var body = json.decode(response.body);
            if(body["error_description"] == "The access token provided has expired") {
              return UserAPIResult.accessTokenExpired;
            }
            return UserAPIResult.clientError;
          case 200:
            return UserAPIResult.success;
          default:
            return UserAPIResult.unknown;
        }
      });
    });
  }

  /// Tries to execute a user API method that requires the use of an access
  /// token. The reason for this method is to refresh the token, if possible.
  /// the method MUST be able to return `UserAPIResult.accessTokenExpired`,
  /// since that indicates to this method that we should refresh it and try
  /// again.<br>
  /// The procedure is as follows:
  /// 1. Attempt to use the API method.
  /// 2. If the API method returns `accessTokenExpired`, then: refresh the
  /// access token.
  /// 3. If the refresh fails, return its error and abort the entire procedure.
  /// 4. The refresh succeeded, execute the API method again and return its
  /// result.
  static Future<UserAPIResult> _tryMethod(
      Future<UserAPIResult> Function() apiMethod) {
    return apiMethod().then((value) async {
      if (value == UserAPIResult.accessTokenExpired) {
        var refreshResult = await refresh();
        if (refreshResult != UserAPIResult.success) {
          return refreshResult;
        }
        return await apiMethod();
      }
      return value;
    });
  }
}
