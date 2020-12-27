import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final Future<UserAPIResult> instantLoginFuture = UserAPIClient.refresh();
  Widget _content(BuildContext context) {
    return Scaffold(
      appBar: LanGuideNavBar(
        showBackIcon: false,
        showFlag: true,
      ),
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
                child: Text(
                  AppLocalizations.of(context).welcome,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text(AppLocalizations.of(context).login),
                onPressed: () => Navigator.pushNamed(context, Routes.login),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text(AppLocalizations.of(context).register),
                onPressed: () => Navigator.pushNamed(context, Routes.register,
                    arguments: null),
              ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    instantLoginFuture.then((result) {
      if(result == UserAPIResult.success) {
        Navigator.pushNamed(context, Routes.home);
      }
    });

    return FutureBuilder(
        future: instantLoginFuture,
        builder: (context, data) {
          if (data.hasData) {
            return _content(context);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
