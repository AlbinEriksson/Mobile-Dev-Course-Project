import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/languide_button.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:dva232_project/widgets/languide_textfield.dart';
import 'package:flutter/material.dart';

//Login needs to be stateful to have the dispose method called so that the controllers
//no longer are in the memory
class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  //Text input checkers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LanGuideNavBar(),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            //Login Text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Login",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            //Email Texfield
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideTextField(
                controller: emailController,
                hintText: "Email",
                icon: Icons.email,
              ),
            ),
            //Password Textfield
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideTextField(
                obscureText: true,
                controller: passwordController,
                hintText: "Password",
                icon: Icons.lock,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideButton(
                onPressed: () {
                  String dialogue = "Something went wrong";
                  String emailString = emailController.text.toString();
                  String passwordString = passwordController.text.toString();

                  //Cannot register emails or passwords longer than 500 characters long so there
                  //is no need to send info when we know that the input is invalid.

                  RegExp emailExp = new RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+");
                  /*
                    This is the same regex as in register.dart and was taken from there to make
                    sure that the statements are the same. Documentation below:

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
                    * */
                  RegExp passExp = new RegExp(r'(?!.*["\s])');
                  //Checks if the password has any character that can cause a sql injection

                  bool login = false;
                  if (emailString.isEmpty) {
                    dialogue = "Email is empty, please put in an email";
                  }
                  //Cannot register emails or passwords longer than 500 characters long so there
                  //is no need to send info when we know that the input is invalid.
                  else if (emailString.length > 500) {
                    dialogue = "Email is too long, nice try";
                  } else if (passwordString.isEmpty) {
                    dialogue = "Password is empty, please put in a password";
                  } else if (passwordString.length > 500) {
                    dialogue = "Password is too long, nice try";
                  } else if (!emailExp.hasMatch(emailString)) {
                    dialogue = "Invalid email";
                  } else if (!passExp.hasMatch(passwordString)) {
                    dialogue = "Invalid password";
                  } else {
                    sendLogin(context);
                    login = true;
                  }
                  if (!login) {
                    return _validationDialog(context, dialogue);
                  }
                },
                text: "Login",
              ),
            ),

            //Temporary
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LanGuideButton(
                text: "(Temp Dev) Login",
                onPressed: () {
                  Navigator.popAndPushNamed(context, Routes.home);
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

  //Returns an empty string on successful login otherwise it returns an error message
  void sendLogin(BuildContext context) {
    UserAPIClient.login(
            emailController.text.toString(), passwordController.text.toString())
        .then((result) async {
      switch (result) {
        case UserAPIResult.success:
          dispose();
          Navigator.popAndPushNamed(context, Routes.home);
          break;
        case UserAPIResult.serverError:
          _validationDialog(context, "There was a problem with the server. Try again in a moment.");
          break;
        case UserAPIResult.clientError:
          _validationDialog(context, "The app has failed to log you in. Please report this issue to the developers.");
          break;
        case UserAPIResult.noInternetConnection:
          _validationDialog(context, "You must have an internet connection to do that.");
          break;
        case UserAPIResult.invalidCredentials:
          _validationDialog(context, "Invalid email and password combination.");
          break;
        default:
          break;
      }
    });
  }

  //To dispose the controllers that i need to check the input
  //+Performance
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
