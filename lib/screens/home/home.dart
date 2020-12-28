import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/screens/home/home_view.dart';
import 'package:dva232_project/screens/home/settings_view.dart';
import 'package:dva232_project/screens/home/stats_view.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: _appBar(context),
        bottomNavigationBar: _bottomBar(context),
        body: Center(
          child: [
            HomeView(),
            StatsView(),
            SettingsView(),
          ].elementAt(_bottomBarIndex),
        ),
      ),
      onWillPop: () => _logOut(context),
    );
  }

  void _bottomBarItemSelected(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  BottomNavigationBar _bottomBar(BuildContext context) => BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: AppLocalizations.of(context).home),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: AppLocalizations.of(context).stats),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: AppLocalizations.of(context).settings),
        ],
        currentIndex: _bottomBarIndex,
        onTap: _bottomBarItemSelected,
      );

  Widget _appBar(BuildContext context) => LanGuideNavBar(
    onBackIconPressed: () => _backIconPressed(context),
    showBackIcon: true,
    showFlag: true,
  );

  Future<bool> _logOut(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).logOut),
            content: Text(AppLocalizations.of(context).confirmLogOut),
            actions: [
              new TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).no.toUpperCase()),
              ),
              new TextButton(
                onPressed: () {
                  UserAPIClient.logout();
                  Navigator.pop(context, true);
                },
                child: Text(AppLocalizations.of(context).yes.toUpperCase()),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _backIconPressed(BuildContext context) async {
    if (await _logOut(context)) {
      Navigator.pop(context);
    }
  }
}
