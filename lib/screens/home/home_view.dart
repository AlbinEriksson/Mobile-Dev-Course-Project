import 'package:dva232_project/routes.dart';
import 'package:dva232_project/widgets/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const double _buttonSize = 150, _buttonPadding = 24.0;

  String selectedTestRoute;

  GlobalKey _readingBtnKey = GlobalKey();
  GlobalKey _speakingBtnKey = GlobalKey();
  GlobalKey _listeningBtnKey = GlobalKey();
  GlobalKey _writingBtnKey = GlobalKey();
  GlobalKey _vocabularyBtnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    List<Widget> buttons = [
      _takeTestButton(context, Routes.readingTest, Colors.purple[100],
          Icons.remove_red_eye_outlined, "Reading", _readingBtnKey),
      _takeTestButton(context, Routes.speakingTest, Colors.cyan[100],
          Icons.mic_outlined, "Speaking", _speakingBtnKey),
      _takeTestButton(context, Routes.listeningTestIntro, Colors.green[100],
          Icons.hearing_outlined, "Listening", _listeningBtnKey),
      _takeTestButton(context, Routes.writingTest, Colors.orange[100],
          Icons.create_outlined, "Writing", _writingBtnKey),
      _takeTestButton(context, Routes.vocabularyTest, Colors.red[100],
          Icons.spellcheck_outlined, "Vocabulary", _vocabularyBtnKey),
    ];

    return ListView(
      padding: EdgeInsets.all(_buttonPadding),
      children: [
        LayoutBuilder(builder: (context, size) {
          int columns = ((size.maxWidth + _buttonPadding) /
                  (_buttonSize + _buttonPadding))
              .floor();
          int buttonIndex = 0;

          List<Widget> rows = [];

          while (buttonIndex < buttons.length) {
            List<Widget> children = [];
            for (int i = buttonIndex; i < buttonIndex + columns; i++) {
              if (i >= buttons.length) {
                break;
              }
              children.add(buttons[i]);
            }
            rows.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: children));
            rows.add(SizedBox(height: _buttonPadding));
            buttonIndex += columns;
          }

          return Column(children: rows);
        }),
      ],
    );
  }

  Widget _takeTestButton(BuildContext context, String routeTo, Color color,
          IconData icon, String text, GlobalKey key) =>
      CircularButton(
        onPressed: () => _chooseDifficulty(context, color, routeTo, key),
        color: color,
        icon: Icon(icon, size: 60.0),
        text: text,
        size: _buttonSize,
        key: key,
      );

  void _chooseDifficulty(
      BuildContext context, Color color, String routeTo, GlobalKey key) {
    PopupMenu menu = PopupMenu(
      backgroundColor: color,
      lineColor: Colors.white,
      maxColumn: 3,
      items: [
        MenuItem(title: "Easy", textStyle: TextStyle(color: Colors.black)),
        MenuItem(title: "Medium", textStyle: TextStyle(color: Colors.black)),
        MenuItem(title: "Hard", textStyle: TextStyle(color: Colors.black)),
      ],
      onClickMenu: (item) {
        Navigator.pushNamed(context, routeTo,
            arguments: {"difficulty": item.menuTitle});
      },
    );

    menu.show(widgetKey: key);
  }
}
