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

  Widget _bodyWidget;

  Future<Widget> getBodyFuture() async {
    while ((CityData().req_resp == null) || (CityData().limited_req_resp == null)) {
      sleep(const Duration(seconds: 1));
    }
    RequestsResponse req_resp = CityData().req_resp;
    if (globals.userName == globals.guestName)
    {
      req_resp = CityData().limited_req_resp;
    }
    return new Expanded(
      child: new ListView.builder (
        itemCount: req_resp.requests.length,
        itemBuilder: (BuildContext ctxt, int Index) {
          return  new Column( 
            children: [ 
              new ColorSliverButton(
                onPressed: () {
                  ReportData().type = req_resp.requests[Index].service_name;
                  CityData().prevReqIdx = Index;
                  nextPage();
                },
                child: Expanded( 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(req_resp.requests[Index].service_name + " " + getBasicAddress(req_resp.requests[Index].address)),
                          Row(
                            children: [
                              Text(getTimeString(req_resp.requests[Index].requested_datetime)),
                              Container(
                                width: 15.0,
                              ),
                              Container(
                                width: DeviceData().ButtonHeight * 1.5,
                                height: DeviceData().ButtonHeight * 0.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                    color: getStatusColor(req_resp.requests[Index].status),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      req_resp.requests[Index].status,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ]
                                ),
                              ),
                            ]
                          ),
                        ]
                      ),
                      Icon(Icons.arrow_forward_ios, color: CustomColors.appBarColor),
                    ]
                  ),
                ),
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

  void nextPage() {
    Navigator.of(context).pushNamed('/view_submitted_item');
  }

  Widget _getBody(BuildContext context) {
    Widget retval = Text("Loading submitted reports...");
    if (_bodyWidget != null) {
      retval = _bodyWidget;
    }
    return retval;
  }

  @override
  Widget build(BuildContext context) {
    //TODO: need to show loading... screen while we wait for data
    while ((CityData().req_resp == null) || (CityData().limited_req_resp == null)) {
      sleep(const Duration(seconds: 1));
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
