import 'dart:developer';

import 'package:dva232_project/routes.dart';
import 'package:dva232_project/theme.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:dva232_project/widgets/languide_dropdown.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/widgets/languide_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String role;
  Future<UserAPIResult> userApiResponse;
  final userNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();

  Future<UserAPIResult> _registerFuture = Future.value(UserAPIResult.unknown);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LanGuideNavBar(onBackIconPressed: () => Navigator.pop(context)),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).register,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideTextField(
                icon: Icons.person,
                hintText: AppLocalizations.of(context).name,
                controller: userNameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideTextField(
                icon: Icons.email,
                hintText: AppLocalizations.of(context).email,
                controller: emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideTextField(
                icon: Icons.lock,
                hintText: AppLocalizations.of(context).password,
                obscureText: true,
                controller: passwordController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideTextField(
                icon: Icons.lock,
                hintText: AppLocalizations.of(context).confirmPassword,
                obscureText: true,
                controller: confirmPasswordController,
              ),
            ),
            LanGuideDropdown(
              hintText: AppLocalizations.of(context).selectRole,
              onChanged: (String value) {
                role = value;
              },
              items: {
                "student": AppLocalizations.of(context).student,
                "teacher": AppLocalizations.of(context).teacher,
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                child: FutureBuilder(
                  future: _registerFuture,
                  builder: (context, data) {
                    if (data.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Text(AppLocalizations.of(context).register);
                    }
                  },
                ),
                onPressed: () {
                  String dialogue = "";
                  bool register = false;

                  RegExp emailExp = new RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+");
                  /*
                   *Checks if the structure of the email is correct (i.e test@example.com).
                   *Does not allow for double @ or double .
                   *Makes sure no illegal double-quotes is used. However, the single-quote is allowed and therefore all strings need to be double-quoted to ensure consistency.
                   *The domain can only have alphabetical and numerical characters, while the domain type can only have alphabetical characters.
                   *
                   * Drawbacks:
                   *   - The problem is that no established domain lengths are done, so illegal domain lengths are let through.
                   *   - The above point is also true for the domain type as it is not checked for length.
                   *
                   * We realize that these drawbacks exist but choose to not over-complicate the validation. We could simply send an email-verification to that given adress
                   * and if they don't respond, more than likely their email is either incorrect or the user who created the account is not the real owner.
                   * //Rikard
                   */
                  RegExp strongPasswordRegex = new RegExp(
                      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");
                  RegExp mediumPasswordRegex = new RegExp(
                      r"^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{6,})");
                  /*
                   * The strong version of password regex has strict requirements:
                   *   - At least 1 lowercase alphabetical character
                   *   - At least 1 uppercase alphabetical character
                   *   - At least 1 numerical character
                   *   - At least 1 special character
                   *   - Has to be at least 8 characters long
                   *
                   * The medium version of password regex has less strict guidelines, therefore the regex becomes more complex:
                   *   - The structure of the regex includes OR, between 3 different combinations of lowercase alphabetical, uppercase alphabetical and numerical characters.
                   *   - You either have:
                   *       - 1 lowercase + 1 upper case alphabetical OR
                   *       - 1 lowercase alphabetical + 1 numerical character OR
                   *       - 1 uppercase alphabetical + 1 numerical character
                   *   - Has to be at least 6 characters long
                   *
                   * For simplicity we leave out special characters out of the medium version. The reason we don't include a weak version of the regex is also for
                   * simplicity's sake. Because the more lenient we are with the password strength, the complexity of the regex proportionally increases. Furthermore
                   * it's worth noting that we'd like to promote good password security to our potential customers, even if it means that it becomes less convenient
                   * for them to create an account to meet our security standards.
                   * //Rikard
                   */

                  // Remove trailing, leading and consecutive spaces from username.
                  String username = userNameController.text
                      .trim()
                      .replaceAllMapped(RegExp(r" {2,}"), (match) => " ");

                  if (username.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty ||
                      role == null ||
                      role.length == 0) {
                    dialogue =
                        AppLocalizations.of(context).alertEmptyInputFields;
                  } else if (username.length < 1 || username.length > 80) {
                    dialogue = AppLocalizations.of(context).alertNameLength;
                  } else if (!emailExp.hasMatch(emailController.text)) {
                    dialogue = AppLocalizations.of(context).alertEmailInvalid;
                  } else if (passwordController.text.length < 6) {
                    dialogue = AppLocalizations.of(context).alertPasswordLength;
                  } else if (!strongPasswordRegex
                          .hasMatch(passwordController.text) &&
                      !mediumPasswordRegex.hasMatch(passwordController.text)) {
                    dialogue =
                        AppLocalizations.of(context).alertPasswordInvalid;
                  } else if (!(passwordController.text ==
                      confirmPasswordController.text)) {
                    dialogue =
                        AppLocalizations.of(context).alertPasswordConfirmation;
                  } else {
                    register = true;
                  }
                  if (!register) {
                    return _validationDialog(context, dialogue);
                  } //If any of the above conditions were unmet, the user does not get to create an account
                  else {
                    setState(() {
                      _registerFuture = UserAPIClient.register(
                          emailController.text,
                          passwordController.text,
                          username,
                          "",
                          role.toLowerCase());
                      _registerFuture
                          .then((result) => _handleRegisterResult(result));
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<T> _validationDialog<T>(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(text),
      ),
    );
  }

  void _handleRegisterResult(UserAPIResult result) async {
    switch (result) {
      case UserAPIResult.success:
        await UserAPIClient.login(
            emailController.text, passwordController.text);
        Navigator.popAndPushNamed(context, Routes.home, arguments: null);
        break;
      case UserAPIResult.clientError:
        _validationDialog(
            context, AppLocalizations.of(context).alertRegisterFailed);
        break;
      case UserAPIResult.emailInUse:
        _validationDialog(
            context, AppLocalizations.of(context).alertEmailInUse);
        break;
      case UserAPIResult.roleNotFound:
        _validationDialog(
            context, AppLocalizations.of(context).alertInvalidRole);
        break;
      case UserAPIResult.serverError:
        _validationDialog(
            context, AppLocalizations.of(context).alertServerProblem);
        break;
      case UserAPIResult.noInternetConnection:
        _validationDialog(
            context, AppLocalizations.of(context).alertInternetConnection);
        break;
      case UserAPIResult.serverUnavailable:
        _validationDialog(
            context, AppLocalizations.of(context).alertServerMaintenance);
        break;
      default:
        break;
    }
  }
}
