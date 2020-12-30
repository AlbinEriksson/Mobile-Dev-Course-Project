import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

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
  noInternetConnection,
  serverUnavailable,
  unknown,
}

class TestResult {
  final String testType;
  final String difficulty;
  final double accuracy;
  final DateTime time;

  TestResult(this.testType, this.difficulty, this.accuracy, this.time);
}

class TestResultsResponse {
  final UserAPIResult apiResult;
  final List<TestResult> testResults;

  TestResultsResponse({@required this.apiResult, this.testResults});
}

class UserInfoResponse {
  final UserAPIResult apiResult;
  final String userId;
  final String name;
  final bool emailVerified;
  final String role;

  UserInfoResponse(
      {this.apiResult: UserAPIResult.success,
      this.userId,
      this.name,
      this.emailVerified,
      this.role});
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
  static UserInfoResponse _userInfo;

  static final LocalStorage _storage = LocalStorage("user_api_client.json");
  static const String _storageRefreshTokenKey = "refresh_token";
  static const String _storageUserInfoKey = "user_info";

  static Future<void> init() async {
    await _storage.ready;

    _refreshToken = _storage.getItem(_storageRefreshTokenKey);

    var user = _storage.getItem(_storageUserInfoKey);
    if(user != null) {
      _userInfo = UserInfoResponse(
        apiResult: UserAPIResult.success,
        userId: user["userId"],
        name: user["name"],
        emailVerified: user["emailVerified"],
        role: user["role"],
      );
    }
  }

  static void _setTokenData(
      String accessToken, String refreshToken, String userScope) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userScope = userScope;

    _storage.setItem(_storageRefreshTokenKey, _refreshToken);
  }

  static void _setUserData(
      String userId, String userName, bool emailVerified, String role) {
    _userInfo = UserInfoResponse(
      apiResult: UserAPIResult.success,
      userId: userId,
      name: userName,
      emailVerified: emailVerified,
      role: role,
    );

    _storage.setItem(_storageUserInfoKey, {
      "userId": userId,
      "name": userName,
      "emailVerified": emailVerified,
      "role": role,
    });
  }

  /// Logs in a user. The access token, refresh token and scope will be stored
  /// statically in the UserAPIClient class, and cached accordingly.
  /// Possible result types (see enum UserAPIResult):
  /// - clientError
  /// - invalidCredentials
  /// - success
  /// - unknown
  /// - noInternetConnection
  /// - serverUnavailable
  static Future<UserAPIResult> login(String email, String password) async {
    try {
      return await http
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
    } on SocketException catch (e) {
      return _handleSocketException(e);
    }
  }

  /// Deletes cached data such as access and refresh token, which means the user
  /// must login again to be able to use the API on their account.
  static void logout() {
    _storage.clear();
    _accessToken = null;
    _refreshToken = null;
    _userScope = null;
    _userInfo = null;
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
  /// - noInternetConnection
  /// - serverUnavailable
  static Future<UserAPIResult> register(String email, String password,
      String firstName, String lastName, String role) async {
    if (lastName != null && lastName.trim().isEmpty) {
      lastName = null;
    }
    try {
      return await http
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
    } on SocketException catch (e) {
      return _handleSocketException(e);
    }
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
  /// - noInternetConnection
  /// - serverUnavailable
  static Future<UserAPIResult> refresh() async {
    _refreshToken = _storage.getItem(_storageRefreshTokenKey);
    if (_refreshToken == null || _refreshToken.isEmpty) {
      return Future.value(UserAPIResult.noRefreshToken);
    }
    try {
      return await http
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
    } on SocketException catch (e) {
      return _handleSocketException(e);
    }
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
  /// - noInternetConnection
  /// - serverUnavailable
  static Future<UserAPIResult> submitTestResults(
      String testType, String difficulty, double accuracy) async {
    try {
      return await _tryMethod(() {
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
              if (body["error_description"] ==
                  "The access token provided has expired") {
                return UserAPIResult.accessTokenExpired;
              }
              return UserAPIResult.clientError;
            case 200:
              return UserAPIResult.success;
            default:
              return UserAPIResult.unknown;
          }
        });
      }, (error) => error);
    } on SocketException catch (e) {
      return _handleSocketException(e);
    }
  }

  /// Gets multiple test results from the current user. Uses the internally
  /// stored access token, so there's no need to provide it as an argument for
  /// this method.<br>
  /// The `unit` parameter can be "amount", "days", "weeks", "months" or
  /// "years". For example, if `unit` is "weeks" and `amount` is 5, it will
  /// return test results from the past 5 weeks. Using the "amount" unit will
  /// instead return a specified amount of test results, starting from the most
  /// recent one.<br>
  /// All test results are returned in order of most recent first.<br>
  /// Possible result types (see enum UserAPIResult):
  /// - clientError
  /// - accessTokenExpired (it will try to refresh it <b>once</b> before
  /// returning this result).
  /// - noRefreshToken
  /// - refreshTokenExpired
  /// - success
  /// - unknown
  /// - noInternetConnection
  /// - serverUnavailable
  static Future<TestResultsResponse> getTestResults(
      String testType, String unit, int amount,
      [String difficulty]) async {
    if (difficulty == null) {
      difficulty = "";
    }
    try {
      return await _tryMethod(() {
        return http.get(
          "$_apiUrl/results.php?type=$testType&unit=$unit&amount=$amount&difficulty=$difficulty",
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_accessToken"
          },
        ).then((response) {
          switch (response.statusCode) {
            case 400:
            case 404:
              log("[ERROR] User API Client failed to make a proper request to submit test results:");
              log(response.body);
              return TestResultsResponse(apiResult: UserAPIResult.clientError);
            case 401:
              var body = json.decode(response.body);
              if (body["error_description"] ==
                  "The access token provided has expired") {
                return TestResultsResponse(
                    apiResult: UserAPIResult.accessTokenExpired);
              }
              return TestResultsResponse(apiResult: UserAPIResult.clientError);
            case 200:
              var body = json.decode(response.body);
              List<TestResult> testResults = [];
              for (var testResult in body["data"]) {
                testResults.add(TestResult(
                    testType,
                    difficulty == "" ? testResult["difficulty"] : difficulty,
                    testResult["accuracy"],
                    DateTime.parse(testResult["timestamp"])));
              }
              return TestResultsResponse(
                  apiResult: UserAPIResult.success, testResults: testResults);
            default:
              return TestResultsResponse(apiResult: UserAPIResult.unknown);
          }
        });
      }, (error) => TestResultsResponse(apiResult: error),
          (value) => value.apiResult);
    } on SocketException catch (e) {
      return TestResultsResponse(apiResult: await _handleSocketException(e));
    }
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
  static Future<T> _tryMethod<T>(
      Future<T> Function() apiMethod, T Function(UserAPIResult) refreshFailed,
      [UserAPIResult Function(T) apiResult]) {
    return apiMethod().then((value) async {
      bool isExpired;
      if (apiResult == null) {
        isExpired = value == UserAPIResult.accessTokenExpired;
      } else {
        isExpired = apiResult(value) == UserAPIResult.accessTokenExpired;
      }
      if (isExpired) {
        var refreshResult = await refresh();
        if (refreshResult != UserAPIResult.success) {
          return refreshFailed(refreshResult);
        }
        return await apiMethod();
      }
      return value;
    });
  }

  static Future<UserAPIResult> _handleSocketException(SocketException e) async {
    switch (e.osError?.errorCode) {
      case 101:
        return UserAPIResult.noInternetConnection;
      case 110:
        return UserAPIResult.serverUnavailable;
    }

    if(e.message.startsWith("HTTP connection timed out")) {
      return UserAPIResult.serverUnavailable;
    }

    log(e.toString());
    return UserAPIResult.unknown;
  }

  /// Gets user info. Uses the internally stored access token, so there's
  /// no need to provide it as an argument for this method.
  /// Possible result types (see enum UserAPIResult):
  /// - clientError
  /// - accessTokenExpired (it will try to refresh it <b>once</b> before
  /// returning this result).
  /// - noRefreshToken
  /// - refreshTokenExpired
  /// - success
  /// - unknown
  /// - noInternetConnection
  /// - serverUnavailable
  static Future<UserInfoResponse> getUserInfo() async {
    if(_userInfo != null) {
      return Future.value(_userInfo);
    }

    try {
      return await _tryMethod(() {
        return http.get("$_apiUrl/whoami.php", headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_accessToken"
        }).then((response) {
          switch (response.statusCode) {
            case 500:
              return UserInfoResponse(apiResult: UserAPIResult.serverError);
            case 400:
            case 404:
              log("[ERROR] User API Client failed to make a proper request to submit test results:");
              log(response.body);
              return UserInfoResponse(apiResult: UserAPIResult.clientError);
            case 401:
              var body = json.decode(response.body);
              if (body["error_description"] ==
                  "The access token provided has expired") {
                return UserInfoResponse(
                    apiResult: UserAPIResult.accessTokenExpired);
              }
              return UserInfoResponse(apiResult: UserAPIResult.clientError);
            case 200:
              var body = json.decode(response.body);
              var user = body["data"];
              String userName = user["first_name"];

              if (user["last_name"] != null) {
                userName += " ${user["last_name"]}";
              }

              _setUserData(user["user_id"], userName, user["email_verified"], user["scope"]);

              return UserInfoResponse(
                apiResult: UserAPIResult.success,
                userId: user["user_id"],
                name: userName,
                emailVerified: user["email_verified"],
                role: user["scope"],
              );
            default:
              return UserInfoResponse(apiResult: UserAPIResult.unknown);
          }
        });
      }, (error) => UserInfoResponse(apiResult: error),
              (value) => value.apiResult);
    } on SocketException catch (e) {
      return UserInfoResponse(apiResult: await _handleSocketException(e));
    }
  }
}
