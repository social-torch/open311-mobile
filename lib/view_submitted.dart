import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'description.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'bottom_app_bar.dart';


class ViewSubmittedPage extends Page {
  ViewSubmittedPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const ViewSubmittedBody();
  }
}

class ViewSubmittedBody extends StatefulWidget {
  const ViewSubmittedBody();

  @override
  State<StatefulWidget> createState() => ViewSubmittedBodyState();
}
          
class ViewSubmittedBodyState extends State<ViewSubmittedBody> {
  ViewSubmittedBodyState();

  @override
  void initState() {
    super.initState();
  }

  void nextPage() {
    Navigator.of(context).pushNamed('/view_submitted');
  }

  @override
  Widget build(BuildContext context) {
    //TODO: make real!, create some fake data for now this should come from back end
    if ( PreviousSubmittedData().issues == null ) {
      PreviousSubmittedData().issues = new List<String>();;
      PreviousSubmittedData().issues.add("Garbage on Girard St.");
    }

    return new Scaffold (
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
      ),
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
                      'Submitted Service Requests',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 30.0),
                Expanded(
                  child: new ListView.builder (
                    itemCount: PreviousSubmittedData().issues.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return  new ColorSliverButton(
                        onPressed: () {
                          ReportData().type = PreviousSubmittedData().issues[Index];
                          nextPage();
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(PreviousSubmittedData().issues[Index]),
                                Row(
                                  children: [
                                    Text("12/25/18, 1:39pm"),
                                    Container(
                                      width: 50.0,
                                      height: 15.0,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                          color: CustomColors.salmon,
                                      ),
                                    ),
                                  ]
                                ),
                              ]
                            ),
                            Icon(Icons.arrow_forward_ios, color: CustomColors.appBarColor),
                          ]
                        ),
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
