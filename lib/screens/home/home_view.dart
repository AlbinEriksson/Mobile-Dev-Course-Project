import 'package:dva232_project/routes.dart';
import 'package:dva232_project/theme.dart';
import 'package:dva232_project/widgets/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      _takeTestButton(
          context,
          Routes.readingTest,
          LanGuideTheme.readingTestColor(context),
          Icons.remove_red_eye_outlined,
          AppLocalizations.of(context).reading,
          _readingBtnKey),
      _takeTestButton(
          context,
          Routes.speakingTest,
          LanGuideTheme.speakingTestColor(context),
          Icons.mic_outlined,
          AppLocalizations.of(context).speaking,
          _speakingBtnKey),
      _takeTestButton(
          context,
          Routes.listeningTestIntro,
          LanGuideTheme.listeningTestColor(context),
          Icons.hearing_outlined,
          AppLocalizations.of(context).listening,
          _listeningBtnKey),
      _takeTestButton(
          context,
          Routes.writingTest,
          LanGuideTheme.writingTestColor(context),
          Icons.create_outlined,
          AppLocalizations.of(context).writing,
          _writingBtnKey),
      _takeTestButton(
          context,
          Routes.vocabularyTest,
          LanGuideTheme.vocabularyTestColor(context),
          Icons.spellcheck_outlined,
          AppLocalizations.of(context).vocabulary,
          _vocabularyBtnKey),
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
        icon: Icon(icon, size: 60.0, color: Colors.white),
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
        MenuItem(
          title: AppLocalizations.of(context).easy,
          textStyle: TextStyle(color: Colors.black),
          userInfo: "easy",
        ),
        MenuItem(
          title: AppLocalizations.of(context).medium,
          textStyle: TextStyle(color: Colors.black),
          userInfo: "medium",
        ),
        MenuItem(
          title: AppLocalizations.of(context).hard,
          textStyle: TextStyle(color: Colors.black),
          userInfo: "hard",
        ),
      ],
      onClickMenu: (item) {
        MenuItem menuItem = item as MenuItem;
        Navigator.pushNamed(context, routeTo,
            arguments: {"difficulty": menuItem.userInfo});
      },
    );

    menu.show(widgetKey: key);
  }
}
