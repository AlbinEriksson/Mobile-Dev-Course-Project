# dva232_project

Project for MDH course DVA232

## Build
 1. Configure the URL for user API in `lib/client/user_api_client.dart` (around line 64). See the `user_api_server` folder for instructions to run the user API server.
 2. Do the instructions under section "Signing the app" at https://flutter.dev/docs/deployment/android.
 3. Run the following command in the root of the project to build the APK.
```
flutter build apk --obfuscate --split-debug-info=/dva232_project/debuginfo --split-per-abi
```
