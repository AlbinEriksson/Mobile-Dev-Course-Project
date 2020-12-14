import 'package:dva232_project/routes.dart';

import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name; //Dessa bör kunna användas till backend-delen
  String email;
  String password;
  String confirmPassword;

  String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(0.0),
                child: Text(
                  'Account Info',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 40.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                child: Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextField(
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      //color: Colors.purple,
                    ),
                    hintText: 'Name (Last name is optional)',
                    hintStyle: TextStyle(
                      //color: Colors.purple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                    ),
                    /*focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                    ),*/
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextField(
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      //color: Colors.purple,
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      //color: Colors.purple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextField(
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      //color: Colors.purple,
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      //color: Colors.purple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextField(
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      //color: Colors.purple,
                    ),
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                      //color: Colors.purple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      confirmPassword = value;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                width: 335,
                height: 60,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.purple,
                        width: 1.0,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      "Select Role",
                      style: TextStyle(fontSize: 17.0
                          //fontWeight: FontWeight.bold,
                          ),
                    ),
                    value: role,
                    items: <String>['Student', 'Teacher']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 17.0
                              //fontWeight: FontWeight.bold,
                              ),
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                //margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                width: 300,
                height: 100,
                child: RaisedButton(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  color: Colors.purple,
                  onPressed: () => Navigator.popAndPushNamed(
                      context, Routes.home,
                      arguments: null),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
