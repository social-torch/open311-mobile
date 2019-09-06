import 'package:flutter/material.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import 'description.dart';
import 'bottom_app_bar.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';


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

 Widget _bodyWidget;

  Future<Widget> getBodyFuture() async {
    while (CityData().serv_resp == null) {
      sleep(const Duration(seconds: 1));
    } 
    return new Expanded(
      child: new ListView.builder (
        itemCount: CityData().serv_resp.services.length,
        itemBuilder: (BuildContext ctxt, int Index) {
          return new Column(
            children: [
              new ColorSliverButton( 
                onPressed: () {
                  ReportData().type = CityData().serv_resp.services[Index].service_name;
                  ReportData().type_code = CityData().serv_resp.services[Index].service_code;
                  descPage();
                },
                child: Expanded( child: Column(children: [ Tooltip(message: CityData().serv_resp.services[Index].description, child: Text(CityData().serv_resp.services[Index].service_name)) ] ),),
              ),
              Container(height: 15.0),
            ]
          );
        }
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getBodyFuture().then((newBodyWidget) {
      setState(() {
        _bodyWidget = newBodyWidget;
      });
    });
  }
  
  Widget _getBody(BuildContext context) {
    Widget retval = Text("Loading report types...");
    if (_bodyWidget != null) {
      retval = _bodyWidget;
    }
    return retval;
  }

  void descPage() {
    Navigator.of(context).pushNamed('/description');
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
                _getBody(context),
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


