import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/routes.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  Widget _content(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            SizedBox(height: 20),
            Container(
                padding: EdgeInsets.all(30.0),
                margin: EdgeInsets.all(30.0),
                child: Image(image: AssetImage('images/logo.png'))),
            Container(
              //color: Colors.blue,
              child: Text(
                'Welcome!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 40.0,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 300,
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                color: Colors.purple,
                splashColor: Colors.pink,
                child: Text('Login',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 21.0,
                    )),
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.login, arguments: null),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 300,
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                color: Colors.purple,
                splashColor: Colors.pink,
                child: Text('Register',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20.0,
                    )),
                onPressed: () => Navigator.pushNamed(context, Routes.register,
                    arguments: null),
              ),
            ),
          ])),
    );
  }
  /// - clientError
  /// - noRefreshToken
  /// - refreshTokenExpired
  /// - success
  /// - unknown
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: UserAPIClient.refresh(),
      builder: (context, data){
        if(data.hasData){
          if(data.data == UserAPIResult.success){
            Navigator.pushNamed(context, Routes.login, arguments: null);
          }
          return _content(context);
        }
        else{
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}

