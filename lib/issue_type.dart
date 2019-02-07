import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'description.dart';
import 'bottom_app_bar.dart';
import 'custom_widgets.dart';


class IssueTypePage extends Page {
  IssueTypePage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const IssueTypeBody();
  }
}

class IssueTypeBody extends StatefulWidget {
  const IssueTypeBody();

  @override
  State<StatefulWidget> createState() => IssueTypeBodyState();
}
          
class IssueTypeBodyState extends State<IssueTypeBody> {
  IssueTypeBodyState();

  @override
  void initState() {
    super.initState();
  }

  void descPage() {
    Navigator.of(context).pushNamed('/description');
  }

  @override
  Widget build(BuildContext context) {

    //create some fake data for now this should come from back end
    if ( CityData().issues == null ) { 
      CityData().issues = new List<String>();;
      CityData().issues.add("Animals");
      CityData().issues.add("Garbage and Recycling");
      CityData().issues.add("Health");
      CityData().issues.add("Home and Buildings");
      CityData().issues.add("Parking");
      CityData().issues.add("Transportation and Streets");
    }
    return new Scaffold (
      appBar: AppBar(title: Text(APP_NAME)),
      bottomNavigationBar: commonBottomBar(context),
      body: Row (
        children: [ 
          Container(
            width: 36.0,
          ),
          Expanded( 
            child: Column(
              children: [
                Container(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: Text(
                      'Select a Issue Type',
                      textAlign: TextAlign.left,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 30.0),
                ProgressDots(
                  stage: 2,
                  numStages: 4,
                ),
                Container(height: 30.0),
                Expanded(
                  child: new ListView.builder (
                    itemCount: CityData().issues.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return  new ColorSliverButton( 
                        onPressed: () {
                          ReportData().type = CityData().issues[Index];
                          descPage();
                        },
                        child: Text(CityData().issues[Index]),
                      );
                    }
                  ),
                ),
              ]
            ),
          ),
          Container(
            width: 36.0,
          ),
        ]
      ),
    );
  }
}

