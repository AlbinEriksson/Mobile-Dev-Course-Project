import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/routes.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  Widget _content(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(30.0),
                margin: EdgeInsets.all(30.0),
                child: Image(
                  image: AssetImage('images/logo.png'),
                ),
              ),
              Center(
                //color: Colors.blue,
                child: Text(
                  'Welcome!',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () => Navigator.pushNamed(context, Routes.login),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () => Navigator.pushNamed(context, Routes.register,
                    arguments: null),
              ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserAPIClient.refresh(),
        builder: (context, data) {
          if (data.hasData) {
            if (data.data == UserAPIResult.success) {
              Navigator.pushNamed(context, Routes.login, arguments: null);
            }
            return _content(context);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
