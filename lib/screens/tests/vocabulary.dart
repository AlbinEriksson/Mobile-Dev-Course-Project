import 'package:dva232_project/screens/tests/shared.dart';
import 'package:dva232_project/widgets/languide_navbar.dart';
import 'package:flutter/material.dart';

class VocabularyTest extends StatefulWidget {
  @override
  _VocabularyTestState createState() => _VocabularyTestState();
}

class _VocabularyTestState extends State<VocabularyTest> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => backPressed(context, true),
      child: Scaffold(
        appBar: LanGuideNavBar(
            onBackIconPressed: () => backIconPressed(context, true)),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: "The European Union (EU) has been providing "),
                  _spellCheckField("budget"),
                  TextSpan(
                      text:
                          " support to Cambodia in the education sector since 2003 on the basis of sound and comprehensive plans to improve performance in the sector and to gradually implement public finance management (PFM) reforms, as well as continued improvements in both areas. Over the same period Cambodia has made steady progress in poverty "),
                  _spellCheckField("redduction"),
                  TextSpan(text: " in the last decade underpinned by high "),
                  _spellCheckField("economic"),
                  TextSpan(
                      text:
                          " growth. However important challenges remain in the education sector, such as the need to increase enrolment and retention at secondary level, to improve quality at all levels and to reduce regional and social disparities. Addressing these requires Government to increase its resources "),
                  _spellCheckField("alocated"),
                  TextSpan(
                      text:
                          " to the sector. The further scaling up of budget support provided by the EU to the sector, as proposed, building on a recently agreed programme, will enhance the support to Government's efforts to reverse the fall in the share of Government "),
                  _spellCheckField("reccurent"),
                  TextSpan(
                      text:
                          " funds provided to the Ministry of Education, Youth and Sports (MoEYS) by supporting an increase of Government "),
                  _spellCheckField("resorses"),
                  TextSpan(text: " "),
                  _spellCheckField("avarded"),
                  TextSpan(
                      text:
                          " to specific interventions aimed at improving key service delivery indicators related to access, equity and quality in the sector. It will also encourage Government to continue strengthening its PFM systems and increase budget "),
                  _spellCheckField("transparrency"),
                  TextSpan(
                      text:
                          ". The proposed amount is a top up to a recently signed programme covering the period 2014-2016. An Addendum to the ongoing Financing "),
                  _spellCheckField("Agrement"),
                  TextSpan(
                      text:
                          " will be signed. This additional amount should cover one additional year and in effect lead to more than a doubling of the yearly amount for the period 2014-2016. This increased level will be possibly "),
                  _spellCheckField("maintained"),
                  TextSpan(text: " in 2017 with the additional financing "),
                  _spellCheckField("foresen"),
                  TextSpan(text: " under the MIP 2014-2020. "),
                  TextSpan(text: " (European Comission, 2014)"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _spellCheckField(String suggestion) {
    return TextSpan(
      text: suggestion,

    );
  }
}
