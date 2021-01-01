import 'dart:developer';

import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/theme.dart';
import 'package:dva232_project/widgets/languide_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatsView extends StatefulWidget {
  @override
  _StatsViewState createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  DateTime lowerBound;
  DateTime upperBound = DateTime.now();

  String pastTimeUnit = "weeks";

  @override
  Widget build(BuildContext context) {
    lowerBound = DateTime.now().subtract(Duration(days: _timeUnitInDays()));

    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        _lowerBoundSelector(),
        _chartFutureBuilder(AppLocalizations.of(context).reading,
            Icons.remove_red_eye_outlined, "reading"),
        _chartFutureBuilder(AppLocalizations.of(context).speaking,
            Icons.mic_outlined, "speaking"),
        _chartFutureBuilder(AppLocalizations.of(context).listening,
            Icons.hearing_outlined, "listening"),
        _chartFutureBuilder(AppLocalizations.of(context).writing,
            Icons.create_outlined, "writing"),
        _chartFutureBuilder(AppLocalizations.of(context).vocabulary,
            Icons.spellcheck_outlined, "vocabulary"),
      ],
    );
  }

  int _timeUnitInDays() {
    switch (pastTimeUnit) {
      case "days":
        return 1;
      case "weeks":
        return 7;
      case "months":
        return 30;
      case "years":
        return 365;
    }
    return 7;
  }

  Widget _lowerBoundSelector() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(AppLocalizations.of(context).showResultsFrom),
          ),
          LanGuideDropdown(
            hintText: AppLocalizations.of(context).selectTime,
            onChanged: (value) {
              setState(() {
                pastTimeUnit = value;
              });
            },
            items: {
              "days": AppLocalizations.of(context).past24Hours,
              "weeks": AppLocalizations.of(context).pastWeek,
              "months": AppLocalizations.of(context).pastMonth,
              "years": AppLocalizations.of(context).pastYear,
            },
            initialValue: pastTimeUnit,
          ),
        ],
      );

  Widget _chartFutureBuilder(String testTitle, IconData icon, String testType) {
    Future<TestResultsResponse> resultsFuture =
        UserAPIClient.getTestResults(testType, pastTimeUnit, 1);
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(testTitle),
      children: [
        SizedBox(
          height: 250.0,
          child: FutureBuilder(
            future: resultsFuture,
            builder: (context, data) {
              if (data.connectionState == ConnectionState.waiting ||
                  data.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                TestResultsResponse response = data.data;
                return _handleResultsResponse(response);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _handleResultsResponse(TestResultsResponse response) {
    switch (response.apiResult) {
      case UserAPIResult.success:
        return _testResultsChart(response.testResults);
        break;
      case UserAPIResult.clientError:
        return Center(
            child: Text(AppLocalizations.of(context).alertRetrieveTestResults));
        break;
      case UserAPIResult.accessTokenExpired:
      case UserAPIResult.noRefreshToken:
        return Center(
            child: Text(AppLocalizations.of(context).alertSessionError));
        break;
      case UserAPIResult.noInternetConnection:
        return Center(
            child: Text(AppLocalizations.of(context).alertInternetConnection));
        break;
      case UserAPIResult.serverUnavailable:
        return Center(
            child: Text(AppLocalizations.of(context).alertServerMaintenance));
        break;
      default:
        return Center(
            child: Text(AppLocalizations.of(context).alertUnknownError));
        break;
    }
  }

  Widget _testResultsChart(List<TestResult> results) {
    var filtered = _FilteredTestResults.from(results);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Expanded(
            child: TimeSeriesChart(
              <Series<TestResult, DateTime>>[
                _makeSeries(
                    "easy", MaterialPalette.green.shadeDefault, filtered.easy),
                _makeSeries(
                    "medium",
                    MaterialPalette.yellow.shadeDefault.darker,
                    filtered.medium),
                _makeSeries(
                    "hard", MaterialPalette.red.shadeDefault, filtered.hard),
              ],
              defaultRenderer: LineRendererConfig(
                includeArea: true,
              ),
              animate: true,
            ),
          ),
          _chartLegend(),
        ],
      ),
    );
  }

  Series<TestResult, DateTime> _makeSeries(
          String id, Color color, List<TestResult> filteredResults) =>
      Series<TestResult, DateTime>(
        id: id,
        colorFn: (_, __) => color,
        domainFn: (TestResult result, _) => result.time,
        measureFn: (TestResult result, _) => result.accuracy,
        data: filteredResults,
        domainLowerBoundFn: (_, __) => lowerBound,
        domainUpperBoundFn: (_, __) => upperBound,
      );

  Widget _chartLegend() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(AppLocalizations.of(context).easy,
              style: LanGuideTheme.easyStatsLegend(context)),
          Text(AppLocalizations.of(context).medium,
              style: LanGuideTheme.mediumStatsLegend(context)),
          Text(AppLocalizations.of(context).hard,
              style: LanGuideTheme.hardStatsLegend(context)),
        ],
      );
}

class _FilteredTestResults {
  final List<TestResult> easy;
  final List<TestResult> medium;
  final List<TestResult> hard;

  _FilteredTestResults._(this.easy, this.medium, this.hard);

  factory _FilteredTestResults.from(List<TestResult> results) {
    List<TestResult> easy = [], medium = [], hard = [];

    for (var result in results) {
      switch (result.difficulty) {
        case "easy":
          easy.add(result);
          break;
        case "medium":
          medium.add(result);
          break;
        case "hard":
          hard.add(result);
          break;
        default:
          log("Invalid difficulty '${result.difficulty}' for filtering test results");
          break;
      }
    }

    return _FilteredTestResults._(easy, medium, hard);
  }
}
