import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/back_nav_button.dart';
import 'package:dva232_project/widgets/replace_nav_button.dart';
import 'package:flutter/material.dart';

//Old login method, keeping it here just in case
class LoginOld extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BackNavButton("Back to front page", Routes.intro),
            ReplaceNavButton("Login", Routes.home),
          ],
        ),
      ),
    );
  }
}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Login Text
          Container(
            margin: EdgeInsets.all(20.0),
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 48,
                color: Colors.purple,
              ),
            ),
          ),

          //Email Texfield
          Container(
            margin: EdgeInsets.all(20.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(),
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(80.0),
                      borderSide: BorderSide(color: Colors.purple)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  )),
            ),
          ),

          //Password Textfield
          Container(
            margin: EdgeInsets.all(20.0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(80.0),
                      borderSide: BorderSide(color: Colors.purple)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  )),
            ),
          ),

          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 120,
              minHeight: 120,
              minWidth: 100,
            ),
            child: Expanded(
              child: Container(
                margin: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: SizedBox(
                  //Match width and height of parents
                  width: double.infinity,
                  height: double.infinity,
                  child: RaisedButton(
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    onPressed: () {
                      String dialouge = "Something went wrong";
                      String emailString = emailController.text.toString();
                      String passwordString =
                          passwordController.text.toString();

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
                        dialouge = "Email is empty, please put in an email";
                      }
                      //Cannot register emails or passwords longer than 500 characters long so there
                      //is no need to send info when we know that the input is invalid.
                      else if (emailString.length > 500) {
                        dialouge = "Email is too long, nice try";
                      } else if (passwordString.isEmpty) {
                        dialouge =
                            "Password is empty, please put in a password";
                      } else if (passwordString.length > 500) {
                        dialouge = "Password is too long, nice try";
                      } else if (!emailExp.hasMatch(emailString)){
                        dialouge = "Invalid email";
                      } else if (!passExp.hasMatch(passwordString)){
                        dialouge = "Invalid password";
                      }
                      else {
                        SendLogin(context);
                        login = true;
                      }
                      if (!login) {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(dialouge),
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          //Temporary
          ReplaceNavButton("(Temp Dev) Login", Routes.home),
        ],
      ),
    );
  }

  //Returns an empty string on successful login otherwise it returns an error message
  void SendLogin(BuildContext context) {

    UserAPIClient.login(emailController.text.toString(), passwordController.text.toString()).then((result) async {
      switch (result) {
        case UserAPIResult.success:
          dispose();
          Navigator.popAndPushNamed(context, Routes.home);
          break;
        case UserAPIResult.serverError:
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Failed to login, please try again"),
              );
            },
          );
          break;
        case UserAPIResult.clientError:
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Failed to login, please check your internet connection and try again"),
              );
            },
          );
          break;
        case UserAPIResult.invalidCredentials:
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Invalid login, please check your email and password"),
              );
            },
          );
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
