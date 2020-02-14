import 'package:flutter/material.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import 'description.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'bottom_app_bar.dart';
import 'utils.dart';
import 'requests.dart';
import "globals.dart" as globals;

class UpdateReportStatusPage extends Page {
  UpdateReportStatusPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const UpdateReportStatusBody();
  }
}

class UpdateReportStatusBody extends StatefulWidget {
  const UpdateReportStatusBody();

  @override
  State<StatefulWidget> createState() => UpdateReportStatusBodyState();
}
          
class UpdateReportStatusBodyState extends State<UpdateReportStatusBody> {
  UpdateReportStatusBodyState();

  void nextPage() {
    Navigator.of(context).pushNamed('/update_report');
  }

  @override
  Widget build(BuildContext context) {
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
                      'Update Status',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: Text(
                      'Current Status: ' + UpdateData().req.status,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(height: 30.0),
                new Expanded(
                  child: new ListView.builder (
                    itemCount: statusTypes.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return  new Column(
                        children: [ 
                          new ColorSliverButton(
                            onPressed: () {
                              UpdateData().status = statusTypes[Index];
                              nextPage();
                            }, 
                            child: Text(statusTypes[Index]),
                          ),
                          Container(height: 15.0),
                        ]
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
