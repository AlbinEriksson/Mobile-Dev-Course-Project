import 'package:dva232_project/screens/home/home.dart';
import 'package:dva232_project/screens/intro/intro.dart';
import 'package:dva232_project/screens/login/login.dart';
import 'package:dva232_project/screens/register/register.dart';
import 'package:dva232_project/screens/results/listening.dart';
import 'package:dva232_project/screens/results/reading.dart';
import 'package:dva232_project/screens/results/speaking.dart';
import 'package:dva232_project/screens/results/vocabulary.dart';
import 'package:dva232_project/screens/results/writing.dart';
import 'package:dva232_project/screens/settings/settings.dart';
import 'package:dva232_project/screens/tests/listening/listening_intro.dart';
import 'package:dva232_project/screens/tests/listening/listening_questions.dart';
import 'package:dva232_project/screens/tests/reading.dart';
import 'package:dva232_project/screens/tests/speaking.dart';
import 'package:dva232_project/screens/tests/vocabulary.dart';
import 'package:dva232_project/screens/tests/writing.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String intro = "/";
  static const String register = "/register";
  static const String login = "/login";
  static const String home = "/home";
  static const String settings = "/settings";
  static const String listeningTestIntro = "/listening";
  static const String listeningTestQuestions="/listening_questions";
  static const String listeningResults = listeningTestIntro + "/results";
  static const String readingTest = "/reading";
  static const String readingResults = readingTest + "/results";
  static const String speakingTest = "/speaking";
  static const String speakingResults = speakingTest + "/results";
  static const String vocabularyTest = "/vocabulary";
  static const String vocabularyResults = vocabularyTest + "/results";
  static const String writingTest = "/writing";
  static const String writingResults = listeningTestIntro + "/results";

  static RouteFactory factory() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;

      Widget screen;
      switch (settings.name) {
        case Routes.intro:
          screen = Intro();
          break;

        case Routes.register:
          screen = Register();
          break;

        case Routes.login:
          screen = Login();
          break;

        case Routes.home:
          screen = Home();
          break;

        case Routes.settings:
          screen = Settings();
          break;

        case Routes.listeningTestIntro:
          screen = ListeningTestIntro();
          break;

        case Routes.listeningTestQuestions:
          screen = ListeningTestQuestions();
          break;

        case Routes.listeningResults:
          screen = ListeningResults();
          break;

        case Routes.readingTest:
          screen = ReadingTest();
          break;

        case Routes.readingResults:
          screen = ReadingResults();
          break;

        case Routes.speakingTest:
          screen = SpeakingTest();
          break;

        case Routes.speakingResults:
          screen = SpeakingResults();
          break;

        case Routes.vocabularyTest:
          screen = VocabularyTest();
          break;

        case Routes.vocabularyResults:
          screen = VocabularyResults();
          break;

        case Routes.writingTest:
          screen = WritingTest();
          break;

        case Routes.writingResults:
          screen = WritingResults();
          break;

        default:
          return null;
      }

      return MaterialPageRoute(builder: (BuildContext context) => screen, settings: settings);
    };
  }
}
