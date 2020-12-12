import 'package:dva232_project/screens/home/account_view.dart';
import 'package:dva232_project/screens/home/home_view.dart';
import 'package:dva232_project/screens/home/settings_view.dart';
import 'package:dva232_project/screens/home/stats_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        bottomNavigationBar: _bottomBar(context),
        body: Center(
          child: [
            HomeView(),
            StatsView(),
            AccountView(),
            SettingsView(),
          ].elementAt(_bottomBarIndex),
        ));
  }

  void _bottomBarItemSelected(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  BottomNavigationBar _bottomBar(BuildContext context) => BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      BottomNavigationBarItem(
          icon: Icon(Icons.settings), label: "Settings"),
    ],
    currentIndex: _bottomBarIndex,
    selectedItemColor: Colors.purple,
    unselectedItemColor: Colors.black,
    onTap: _bottomBarItemSelected,
  );

  Widget _appBar(BuildContext context) => PreferredSize(
      child: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 40.0,
                  onPressed: () => _backIconPressed(context),
                ),
                IconButton(
                  icon: Image.asset("icons/flags/png/gb.png",
                      package: "country_icons"),
                  iconSize: 60.0,
                ),
              ],
            ),
          ),
          // color: Colors.black12,
        ),
      ),
      preferredSize: Size.fromHeight(100));

  Future<bool> _logOut(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Log out"),
        content: Text("Do you want to log out from your account?"),
        actions: [
          new TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("NO"),
          ),
          new TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("YES"),
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