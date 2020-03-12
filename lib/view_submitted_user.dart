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
import 'select_city_common.dart';
import "globals.dart" as globals;

class ViewSubmittedUserPage extends Page {
  ViewSubmittedUserPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const ViewSubmittedUserBody();
  }
}

class ViewSubmittedUserBody extends StatefulWidget {
  const ViewSubmittedUserBody();

  @override
  State<StatefulWidget> createState() => ViewSubmittedUserBodyState();
}
          
class ViewSubmittedUserBodyState extends State<ViewSubmittedUserBody> {
  ViewSubmittedUserBodyState();

  Widget _bodyWidget;
  List<int> users_to_req_idx = List();
  List<Requests> users_list;

  Future<Widget> getBodyFuture() async {
    Widget retval;
    if (globals.userName == globals.guestName) {
      retval = new Expanded(
        child: Column(
          children: [
            Container(height: 30.0),
            SizedBox(
              width: 2 * DeviceData().ButtonHeight,
              child: Image.asset('images/guest_reports.png'),
            ),
            Container(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: Container(
                child: Text(
                  'Log in or Sign up to track and see your submitted reports.',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,
                ),
              ),
            ),
          ]
        ),
      );
    } else {
      while ((CityData().req_resp == null) || (CityData().limited_req_resp == null)) {
        sleep(const Duration(seconds: 1));
      }
      if ( (CityData().users_resp != null) &&
           (CityData().users_resp.submitted_request_ids != null) &&
           (CityData().users_resp.submitted_request_ids.length > 0) ) {
        setState(() {
          users_to_req_idx = List();
          users_list = List();
          for (int i=0; i<CityData().req_resp.requests.length; i++) {
            if (CityData().users_resp.submitted_request_ids.indexWhere((idx) => idx == CityData().req_resp.requests[i].service_request_id) != -1 ) {
              users_list.add(new Requests.fromJson(CityData().req_resp.requests[i].toJson()));
              users_to_req_idx.add(i);
            }
          }
        });
      } else {
        // No requests found, show that to the user
        retval = new Column(
          children: [
            Text("No requests found",
              textScaleFactor: 1.5),
            ColorSliverButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/view_submitted');
                },
              child:Expanded(
                child: Row(children:[Text("Show all requests")])
              )
              )
          ]
        );
        return retval;
      }
      if (users_list == null) { users_list = List(); }
      retval = new Expanded(
        child: new ListView.builder (
          itemCount: users_list.length,
          itemBuilder: (BuildContext ctxt, int Index) {
            return  new Column( 
              children: [ 
                new ColorSliverButton(
                  onPressed: () {
                    CityData().prevReqIdx = users_to_req_idx[Index];
                    nextPage();
                  },
                  child: Expanded( 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(users_list[Index].service_name + " " + getBasicAddress(users_list[Index].address)),
                            Row(
                              children: [
                                Text(getTimeString(users_list[Index].requested_datetime)),
                                Container(
                                  width: 15.0,
                                ),
                                Container(
                                  width: DeviceData().ButtonHeight * 1.5,
                                  height: DeviceData().ButtonHeight * 0.4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                      color: getStatusColor(users_list[Index].status),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        users_list[Index].status,
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
    return retval;
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
    return new WillPopScope(
      onWillPop: () async {
        navPage = "/all_reports";
        Navigator.of(context).pushNamedAndRemoveUntil("/all_reports", ModalRoute.withName('/nada'));
        return false;
      },
      child: new Scaffold(
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
                        'Your Submitted Requests',
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
      ),
    );
  }
}
