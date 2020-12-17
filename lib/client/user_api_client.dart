import 'package:http/http.dart' as http;
import 'dart:convert';

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

  /// Logs in a user, returns a JSON response from the API
  static Future<dynamic> login(String email, String password) {
    return http
        .post("$_apiUrl/token.php",
            headers: {"Content-Type": "application/json"},
            body: json.encode({
              "client_id": _clientLoginId,
              "password": password,
              "username": email,
              "grant_type": "password",
            }))
        .then((response) => json.decode(response.body));
  }

  /// Registers a user, returns a JSON response from the API
  static Future<dynamic> register(String email, String password,
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
        .then((response) => json.decode(response.body));
  }
}
