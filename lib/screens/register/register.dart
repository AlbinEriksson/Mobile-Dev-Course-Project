import 'package:dva232_project/routes.dart';
import 'package:dva232_project/theme.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/widgets/languide_textfield.dart';
import 'package:flutter/material.dart';

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
                  'Account Info',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideTextField(
                icon: Icons.person,
                hintText: 'Name (Last name is optional)',
                controller: userNameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideTextField(
                icon: Icons.email,
                hintText: 'Email',
                controller: emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideTextField(
                icon: Icons.lock,
                hintText: 'Password',
                obscureText: true,
                controller: passwordController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideTextField(
                icon: Icons.lock,
                hintText: 'Confirm Password',
                obscureText: true,
                controller: confirmPasswordController,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              height: 60,
              decoration: LanGuideTheme.inputFieldBorder(),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      "Select Role",
                      style: LanGuideTheme.inputFieldText(),
                    ),
                    value: role,
                    items: <String>['Student', 'Teacher']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: LanGuideTheme.inputFieldText(),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        role = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideButton(
                text: 'Register',
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
                      role == null || role.length == 0) {
                    dialogue = "One or more fields are empty.";
                  } else if (username.length < 1 || username.length > 80) {
                    dialogue = "Username must be between 1 and 80 characters.";
                  } else if (!emailExp.hasMatch(emailController.text)) {
                    dialogue = "Invalid email.";
                  } else if (passwordController.text.length < 6) {
                    dialogue = "Password must be at least 6 characters.";
                  } else if (!strongPasswordRegex
                          .hasMatch(passwordController.text) &&
                      !mediumPasswordRegex.hasMatch(passwordController.text)) {
                    dialogue = "Password must have 2 of the following:\n"
                        "- Lowercase letters\n"
                        "- Uppercase letters\n"
                        "- Numeric digits";
                  } else if (!(passwordController.text ==
                      confirmPasswordController.text)) {
                    dialogue = "The passwords don't match.";
                  } else {
                    register = true;
                  }
                  if (!register) {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(dialogue),
                        );
                      },
                    );
                  } //If any of the above conditions were unmet, the user does not get to create an account
                  else {
                    UserAPIClient.register(
                            emailController.text,
                            passwordController.text,
                            username,
                            "",
                            role.toLowerCase())
                        .then((result) async {
                      switch (result) {
                        case UserAPIResult.success:
                          await UserAPIClient.login(
                              emailController.text, passwordController.text);
                          Navigator.popAndPushNamed(context, Routes.home,
                              arguments: null);
                          break;
                        case UserAPIResult.clientError:
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("The app has failed to register you. Please report this issue to the developers."),
                              );
                            },
                          );
                          break;
                        case UserAPIResult.emailInUse:
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("That email is already in use."),
                              );
                            },
                          );
                          break;
                        case UserAPIResult.roleNotFound:
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("Invalid role. Please report this issue to the developers."),
                              );
                            },
                          );
                          break;
                        case UserAPIResult.serverError:
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("There was a problem with the server. Try again in a moment."),
                              );
                            },
                          );
                          break;
                        case UserAPIResult.noInternetConnection:
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("You must have an internet connection to do that."),
                              );
                            },
                          );
                          break;
                        default:
                          break;
                      }
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
}
