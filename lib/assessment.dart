import 'package:flutter/material.dart';
import 'page.dart';

class AssessmentFaqPage extends Page {
  AssessmentFaqPage() : super(const Icon(Icons.map), 'Assessment Questions');

  @override
  Widget build(BuildContext context) {
    return const AssessmentFaqBody();
  }
}

class AssessmentFaqBody extends StatefulWidget {
  const AssessmentFaqBody();

  @override
  State<StatefulWidget> createState() => AssessmentFaqBodyState();
}

class AssessmentFaqBodyState extends State<AssessmentFaqBody> {
  AssessmentFaqBodyState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: [
          new Column(
            children: <Widget>[
              new Text(
                'TODO: where do we direct assessment questions?',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
