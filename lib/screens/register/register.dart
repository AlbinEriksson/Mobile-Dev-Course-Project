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
            Divider(),
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
                  RegExp userExp = new RegExp(
                      r"^(?=.{1,80}$)(?![_. ])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$");
                  /*
                   * Username has to be 1-80 characters long. It used to be 8-20, but was changed because users are indexed by email address. Hence, the username does not matter significantly.
                   * _ or . are not allowed in the beginning or the end, furthermore they're not allowed inside of the username in the form of: __    _.    ._    ..
                   * a-z, A-Z and 0-9 are all allowed characters.
                   * With this in mind, a valid username looks like: bigPop99, SkadoodleBadoodle56, diamond_pickaxe1337.
                   * An invalid username would look like: big..Pop99, kab__00m, ooga._booga.
                   * //Rikard
                   */
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

                  if (userNameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty ||
                      role.length == 0) {
                    dialogue = "One or more fields are empty.";
                  } else if (!userExp.hasMatch(userNameController.text)) {
                    dialogue = "Invalid username.";
                  } else if (!emailExp.hasMatch(emailController.text)) {
                    dialogue = "Invalid email.";
                  } else if (!strongPasswordRegex
                          .hasMatch(passwordController.text) &&
                      !mediumPasswordRegex.hasMatch(passwordController.text)) {
                    dialogue = "Password is too weak!";
                  } else if (!(passwordController.text ==
                      confirmPasswordController.text)) {
                    dialogue =
                        "Your password confirmation was not the same as the password.";
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
                            userNameController.text,
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
                                content: Text("Error with specification."),
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
                                content: Text("Invalid role."),
                              );
                            },
                          );
                          break;
                        case UserAPIResult.serverError:
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("Failed to register the user."),
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
