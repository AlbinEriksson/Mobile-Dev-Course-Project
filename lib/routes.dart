import 'package:dva232_project/screens/home/home.dart';
import 'package:dva232_project/screens/intro/intro.dart';
import 'package:dva232_project/screens/language/language.dart';
import 'package:dva232_project/screens/login/login.dart';
import 'package:dva232_project/screens/register/register.dart';
import 'package:dva232_project/screens/results/listening.dart';
import 'package:dva232_project/screens/results/reading.dart';
import 'package:dva232_project/screens/results/speaking.dart';
import 'package:dva232_project/screens/results/vocabulary.dart';
import 'package:dva232_project/screens/results/writing.dart';
import 'package:dva232_project/screens/tests/listening/listening_intro.dart';
import 'package:dva232_project/screens/tests/listening/listening_questions.dart';
import 'package:dva232_project/screens/tests/reading.dart';
import 'package:dva232_project/screens/tests/speaking.dart';
import 'package:dva232_project/screens/tests/vocabulary.dart';
import 'package:dva232_project/screens/tests/writing/writing_questions.dart';
import 'package:dva232_project/screens/tests/writing/writing_test.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String intro = "/";
  static const String register = "/register";
  static const String login = "/login";
  static const String home = "/home";
  static const String listeningTestIntro = "/listening";
  static const String listeningTestQuestions = "/listening_questions";
  static const String listeningResults = listeningTestIntro + "/results";
  static const String readingTest = "/reading";
  static const String readingResults = readingTest + "/results";
  static const String speakingTest = "/speaking";
  static const String speakingResults = speakingTest + "/results";
  static const String vocabularyTest = "/vocabulary";
  static const String vocabularyResults = vocabularyTest + "/results";
  static const String writingTest = "/writing";
  static const String writingQuestions = "/writing_questions";
  static const String writingResults = listeningTestIntro + "/results";
  static const String languageSelection = "/language";

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

        case Routes.listeningTestIntro:
          String difficulty = arguments["difficulty"];
          screen = ListeningTestIntro(difficulty);
          break;

        case Routes.listeningTestQuestions:
          String difficulty = arguments["difficulty"];
          screen = ListeningTestQuestions(difficulty);
          break;

        case Routes.listeningResults:
          screen = ListeningResults(
            rightAnswers:arguments["rightAnswers"],
            correctedWordsList:arguments["correctedWordsList"],
            score: arguments["score"],
            difficulty: arguments["difficulty"],
          );
          break;

        case Routes.readingTest:
          String difficulty = arguments["difficulty"];
          screen = ReadingTest(difficulty);
          break;

        case Routes.readingResults:
          screen = ReadingResults(
            score: arguments["score"],
            difficulty: arguments["difficulty"],
          );
          break;

        case Routes.speakingTest:
          String difficulty = arguments["difficulty"];
          screen = SpeakingTest(difficulty);
          break;

        case Routes.speakingResults:
          screen = SpeakingResults(
            score: arguments["score"],
            difficulty: arguments["difficulty"],
          );
          break;

        case Routes.vocabularyTest:
          String difficulty = arguments["difficulty"];
          screen = VocabularyTest(difficulty);
          break;

        case Routes.vocabularyResults:
          screen = VocabularyResults(
            score: arguments["score"],
            editedWords: arguments["editedWords"],
            correctWords: arguments["correctWords"],
            difficulty: arguments["difficulty"],
          );
          break;

        case Routes.writingTest:
          String difficulty = arguments["difficulty"];
          screen = WritingTest(difficulty);
          break;

        case Routes.writingQuestions:
          String difficulty = arguments["difficulty"];
          screen = WritingQuestion(difficulty);
          break;

        case Routes.writingResults:
          screen = WritingResults(
            score: arguments["score"],
            difficulty: arguments["difficulty"],
          );
          break;

        case Routes.languageSelection:
          screen = LanguageSelection();
          break;

        default:
          return null;
      }

      return MaterialPageRoute(
          builder: (BuildContext context) => screen, settings: settings);
    };
  }
}
