import 'package:dva232_project/client/user_api_client.dart';
import 'package:dva232_project/screens/results/shared.dart';
import 'package:flutter/material.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';

class WritingResults extends StatelessWidget {
  final int score;
  final String difficulty;
  final double accuracy;

  final Future<UserAPIResult> submitFuture;

  WritingResults({
    Key key,
    @required this.score,
    @required this.difficulty,
  })  : accuracy = 1.0,
        submitFuture =
        UserAPIClient.submitTestResults("writing", difficulty, 1.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    alertSubmitErrors(context, submitFuture);

    return WillPopScope(
      onWillPop: () => backPressed(context),
      child: Scaffold(
        appBar: LanGuideNavBar(
          showBackIcon: false,
        ),
        body: FutureBuilder(
          future: submitFuture,
          builder: (context, data) {
            if (data.hasData) {
              return _results(context);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _results(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(8.0),
      children: [
        resultsDisplay(context, accuracy, score, 1),
        backHomeButton(context),
      ],
    );
  }
}
