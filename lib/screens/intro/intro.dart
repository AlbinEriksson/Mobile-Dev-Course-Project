import 'package:dva232_project/routes.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
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
}

//Work In Progress - animation for the logo
class SineCurve extends Curve {
  final double count;

  SineCurve({this.count = 3});

  @override
  double transformInternal(double t) {
    var val = sin(count * 2 * pi * t) * 0.5 + 0.5;

    return val;
  }
}

class LogoStatefulWidget extends StatefulWidget {
  LogoStatefulWidget({Key key}) : super(key: key);

  @override
  _LogoStatefulWidgetState createState() => _LogoStatefulWidgetState();
}

class _LogoStatefulWidgetState extends State<LogoStatefulWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          PositionedTransition(
            rect: RelativeRectTween(
              begin: RelativeRect.fromLTRB(0, 10, 0, 0),
              end: RelativeRect.fromLTRB(0, -10, 0, 0),
            ).animate(CurvedAnimation(
              parent: _controller,
              curve: SineCurve(),
            )),
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image(image: AssetImage('images/logo.png'))), // Image
          ),
        ],
      );
    });
  }
}
