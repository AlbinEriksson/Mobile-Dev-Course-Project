import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/widgets/languide_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Future<UserInfoResponse> userInfoFuture = UserAPIClient.getUserInfo();
  Future<void> emailResetPasswordFuture = Future.value();

  String dropDownValue = Settings.getThemeMode().toString().split(".").last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ExpansionTile(
              leading: Icon(Icons.person),
              title: Text(AppLocalizations.of(context).account),
              children: [
                _showUserInfo(AppLocalizations.of(context).name,
                    (user) => user.name, _showNameCannotChange),
                _showUserInfo(AppLocalizations.of(context).email,
                    (user) => user.userId, _showNameCannotChange),
                _showUserInfo(
                  AppLocalizations.of(context).role,
                  (user) => _getRoleString(user.role),
                  () => _showToast(
                      AppLocalizations.of(context).toastCannotChangeRole),
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.lock),
              title: Text(AppLocalizations.of(context).privacyAndSecurity),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _sendEmailResetPassword(),
                    child: FutureBuilder(
                      future: emailResetPasswordFuture,
                      builder: (context, data) {
                        if (data.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Text(
                              AppLocalizations.of(context).resetPassword);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.nightlight_round),
              title: Text(AppLocalizations.of(context).display),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LanGuideDropdown(
                    hintText: AppLocalizations.of(context).theme,
                    initialValue: dropDownValue,
                    onChanged: (String value) {
                      dropDownValue = value;
                      if (dropDownValue == 'light') {
                        Settings.setThemeMode(ThemeMode.light);
                      } else if (dropDownValue == 'dark') {
                        Settings.setThemeMode(ThemeMode.dark);
                      } else if (dropDownValue == 'system') {
                        Settings.setThemeMode(ThemeMode.system);
                      }
                      Settings.updateTheme();
                    },
                    items: {
                      "light": AppLocalizations.of(context).themeLight,
                      "dark": AppLocalizations.of(context).themeDark,
                      "system": AppLocalizations.of(context).themeSystem,
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(String text, [bool long = false]) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _sendEmailResetPassword() {
    setState(() {
      emailResetPasswordFuture = Future.delayed(Duration(seconds: 3));
      emailResetPasswordFuture.whenComplete(() =>
          _showToast(AppLocalizations.of(context).toastResetEmailSent, true));
    });
  }

  void _showNameCannotChange() {
    _showToast(AppLocalizations.of(context).toastCannotChangeName);
  }

  Widget _showUserInfo(String label, String Function(UserInfoResponse) getValue,
      Function() onTap) {
    return ListTile(
      onTap: onTap,
      leading: Text(label),
      trailing: FutureBuilder(
        future: userInfoFuture,
        builder: (context, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Text(getValue(data.data));
          }
        },
      ),
    );
  }

  String _getRoleString(String roleId) {
    switch (roleId) {
      case "student":
        return AppLocalizations.of(context).student;
      case "student":
        return AppLocalizations.of(context).teacher;
    }

    return AppLocalizations.of(context).unknown;
  }
}
