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
class Login extends StatefulWidget{
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
                  hintStyle: TextStyle(
                  ),
                  prefixIcon: Icon(Icons.email,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(80.0),
                      borderSide: BorderSide(color: Colors.purple)

                  ),

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
                      borderSide: BorderSide(color: Colors.purple)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  )),
            ),
          ),


          //Login "Button", prone to change, makes no animation or tapping noise, dislike
          GestureDetector(
            onTap: () {
              String dialouge = "";
              bool login = false;
              if(emailController.text.isEmpty) {
                dialouge = "Email is empty, please put in an email";
              }
              else if (passwordController.text.isEmpty){
                dialouge = "Password is empty, please put in a password";
              }
              else if(emailController.text != passwordController.text){
                dialouge = "Incorrect Credentials, please try again";
              }
              else{
                login = true;
              }
              if(!login) {
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


            child: Container(
              width: 300,
              margin: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(80.0),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,

                ),
              ),
            ),
          ),

          //Temporary
          ReplaceNavButton("(Temp Dev) Login", Routes.home),
          BackNavButton("(Temp Dev) Back to front page", Routes.intro),
        ],
      ),
    );
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
