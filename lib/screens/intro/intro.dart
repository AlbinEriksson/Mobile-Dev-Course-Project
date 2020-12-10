import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/nav_button.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                          Icons.dashboard_rounded,
                          color: Colors.black,
                      ),
                      iconSize: 40.0,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      iconSize: 40.0,
                    )
                  ],
                ),
              ),
            ),
      ), preferredSize: Size.fromHeight(100)),
      body: Center(
        //color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              //color: Colors.blue,
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(20.0),
              child: Text(
                'Welcome!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 40.0,
                ),
              ),
            ),
            Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300,
                  child: RaisedButton(
                    color: Colors.purple,
                    splashColor: Colors.pink,
                    child: Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0,
                        )
                    ),
                    onPressed: () => Navigator.pushNamed(context, Routes.login, arguments: null),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: RaisedButton(
                    color: Colors.purple,
                    splashColor: Colors.pink,
                    child: Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0,
                        )
                    ),
                    onPressed: () => Navigator.pushNamed(context, Routes.register, arguments: null),
                  ),
                ),
              ],
            ),
          ]
        )
      ),
    );
  }
}
