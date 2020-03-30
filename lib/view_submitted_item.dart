import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:open311/requests.dart';
import 'page.dart';
import 'data.dart';
import 'requests.dart';
import 'description.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'bottom_app_bar.dart';
import 'utils.dart';
import "globals.dart" as globals;
import 's3endpoint.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class ViewSubmittedItemPage extends Page {
  ViewSubmittedItemPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const ViewSubmittedItemBody();
  }
}

class ViewSubmittedItemBody extends StatefulWidget {
  const ViewSubmittedItemBody();

  @override
  State<StatefulWidget> createState() => ViewSubmittedItemBodyState();
}
          
class ViewSubmittedItemBodyState extends State<ViewSubmittedItemBody> {
  ViewSubmittedItemBodyState();

  Widget _validImg;

  @override
  void initState() {
    super.initState();
 
    _getValidImgAsync().then((img) {
      setState(() {
        _validImg = img;
      });
    });
  }

  Future<Widget> _getValidImgAsync() async {
    Widget retval;

    if ((CityData().req_resp.requests[CityData().prevReqIdx].media_url ?? "") != "") {
      try {
        final Dio dio = Dio();
        Response s3rep = await dio.get(
          globals.endpoint311base + "/images/fetch/" + CityData().req_resp.requests[CityData().prevReqIdx].media_url,
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: globals.userIdToken
            },
          ),
        );
        S3endpoint s3ep = S3endpoint.fromJson(s3rep.data);
        debugPrint(CityData().req_resp.requests[CityData().prevReqIdx].media_url);
        retval = new Image.network(
          s3ep.url,
          fit: BoxFit.contain,
          height: (MediaQuery.of(context).size.width * 0.5) - 39.0,
          width: (MediaQuery.of(context).size.width * 0.5) - 39.0,
          alignment: Alignment.center,
        );
      } catch(e) {
        debugPrint(e.toString()+e.response.toString());
        print(e);
      }
    }
    return retval;
  }
 
  Widget _getValidImg(BuildContext context) {
    Widget retval = new Text("Loading...");
    if (_validImg != null) {
      retval = _validImg;
    }
    return retval;
  }
 
  Widget _getImg() {
    Widget contents;
    if ((CityData().req_resp.requests[CityData().prevReqIdx].media_url ?? "") == "") {
      // If the request has no image, put up a blank image and note.
      contents = new Column(children: [
        Image.asset("images/blank_image.png"),
        Text("No image available")]);
    } else {
      // Otherwise, get the image async and show it when ready
      contents =  _getValidImg(context);
    }

    Widget retval = new Stack(
      children: [
        new GestureDetector(
          onTap: () {
            CityData().itemSelected = true;
            navPage = "/all_reports";
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/all_reports", ModalRoute.withName("/nada"));
          },
          child: Container(
            height: (MediaQuery
                .of(context)
                .size
                .width * 0.5) - 39.0,
            width: (MediaQuery
                .of(context)
                .size
                .width * 0.5) - 39.0,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: contents
            )
          )]
        );
      return retval;
  }

  /// Create progress blurbs from datetime information and status from backend [open, accepted, inProgress, closed]
  Widget _getProgressList() {
    //Create progress blurbs from datetime information and status from backend [open, accepted, inProgress, closed]
    List<List<String> > status = new List<List<String> >();
    List<String> date_stat_descript = new List<String>();
    Requests req = CityData().req_resp.requests[CityData().prevReqIdx];
    date_stat_descript.add(getTimeString(CityData().req_resp.requests[CityData().prevReqIdx].requested_datetime));
    date_stat_descript.add("Issue Submitted");
    String desc = "N/A";
    if (CityData().req_resp.requests[CityData().prevReqIdx].description != "") {
      desc = CityData().req_resp.requests[CityData().prevReqIdx].description;
    }
    date_stat_descript.add("Description: " + desc);

    status.add(new List<String>.from(date_stat_descript));
    
    date_stat_descript.clear();
    if ( (req.update_datetime != "") &&
        ( (req.status == "open") || (req.status == "inProgress") || (req.status == "closed"))
       ) {
      date_stat_descript.add(getTimeString(req.update_datetime));
      date_stat_descript.add("Issue Received");
      if (req.status == "open") {
        String s_notes = "N/A";
        if (req.status_notes != "") {
          s_notes = req.status_notes;
        }
        date_stat_descript.add("Status Notes: " + s_notes);
      }
      if (req.expected_datetime != "" ) {
        date_stat_descript.add("Thank you for submitting your service request. Your issue has been received by the city and is scheduled to be resolved starting " + getTimeString(req.expected_datetime) + ".");
      }
      else
      {
        date_stat_descript.add("Thank you for submitting your service request. Your issue has been received by the city. You will receive a notification when the request has been addressed by the servicing agency.");
      }
    }
    if ( (req.update_datetime != "") &&
         ( (req.status == "inProgress") || (req.status == "closed") ) )  {
      date_stat_descript.add(getTimeString(req.update_datetime));
      date_stat_descript.add("Issue In Progress");
      if (req.status == "inProgress") {
        String s_notes = "N/A";
        if (req.status_notes != "") {
          s_notes = req.status_notes;
        }
        date_stat_descript.add("Status Notes: " + s_notes);
      }
      date_stat_descript.add("This issue resolution is in progress");
    }

    // TODO: Add items from the auditLog here?

    if ( (req.update_datetime != "") &&
         (req.status == "closed") )  {
      date_stat_descript.add(getTimeString(req.update_datetime));
      date_stat_descript.add("Issue Resolved");
      date_stat_descript.add("This issue has been resolved. Thank you for your submission.");
    }
    if (date_stat_descript.isNotEmpty) {
      status.add(new List<String>.from(date_stat_descript));
    }

    Widget retval = new ListView.builder (
      itemCount: status.length,
      itemBuilder: (BuildContext ctxt, int Index) {
        return new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Column(
              children: [
                new Container(
                  width: 15.0,
                  height: 15.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                new Container(
                  width: 1.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ]
            ),
            new Container(width: 15.0),
            new Expanded( 
              child: new Column( 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(status[Index].elementAt(0)),
                  SizedBox(
                    child: Text(
                      status[Index].elementAt(1),
                      textScaleFactor: 1.3,
                    ),
                  ),
                  Text(status[Index].elementAt(2)),
                  Text(status[Index].length >=4 ? status[Index].elementAt(3) : ""),
                  Text(status[Index].length >=5 ? status[Index].elementAt(4) : ""),
                ]  
              ),
            ),
          ]
        );
      }
    );
    return retval;
  }

  Widget getRequestTitle(Requests req)
  {
    String title;
    List reqs = CityData().users_resp.submitted_request_ids;
    if ( reqs == null ||
         reqs.indexOf(req.service_request_id) == -1) {
      title = 'Request Details';
    } else {
      title = "Your Request Details";
    }
    Widget retval = Text(
      title,
      textAlign: TextAlign.center,
      textScaleFactor: 2.0,
    );
    return retval;
  }

  /// Shows a dialog to allow the user to cancel an open request of theirs
  void showRequestCancelConfirmDialog(Requests req) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Request Cancellation"),
          content: new Text("Are you sure? This can not be undone."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              }
            )
          ],
        );
      },
    );
  }

  /// Returns a widget if the user is able to cancel a request
  /// Request needs to have been submitted by the user and it must still be in the "open" state
  Widget requestCancellationButton(Requests req) {
    // If this isn't our request or if it isn't open, don't show the button
    List reqs = CityData().users_resp.submitted_request_ids;
    if (reqs == null) {
        return Container(height:0);
    }

    if (reqs.indexOf(req.service_request_id) == -1 || req.status != "open") {
      // This isn't our request or the request isn't open, so we can't cancel it.
      return Container(height:0);
    } else {
      // The request is ours and it's open, so it can be cancelled
      return RaisedButton(
        onPressed: () {
          showRequestCancelConfirmDialog(req);
          },
        child: const Text('Cancel Request', style: TextStyle(fontSize: 16)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Requests curReq = CityData().req_resp.requests[CityData().prevReqIdx];
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
                    child: getRequestTitle(curReq),
                  ),
                ),
                Container(height: 30.0),
                Row(
                  children: [
                    _getImg(),
                    Container(width: 6.0),
                    Expanded( 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              curReq.service_name + " " + getBasicAddress(curReq.address),
                              textScaleFactor: 1.2,
                            ),
                          ),
                          Container(height: 10.0),
                          Text(
                            getTimeString(curReq.requested_datetime),
                            textScaleFactor: 1.0,
                          ),
                          Container(height: 10.0),
                          InkWell(
                            onTap: () {
                              if ( (globals.userGroups != null) && globals.userGroups.contains("admin-"+CityData().cities_resp.cities[globals.cityIdx].city_name.split(",")[0].toLowerCase()) ) {
                                UpdateData().req = new Requests.fromJson(curReq.toJson());
                                Navigator.of(context).pushNamed('/update_report_status');
                              }
                            },
                            child: Container(
                              width: DeviceData().ButtonHeight * 1.5,
                              height: DeviceData().ButtonHeight * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                  color: getStatusColor(curReq.status),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    curReq.status,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ]
                              ),
                            ),
                          ),
                          requestCancellationButton(curReq)
                        ]
                      ),
                    ),
                  ]
                ),
                Container(height: 30.0),
                Expanded(
                  child: _getProgressList(),
                ),
                Row(
                  children:[
                    RaisedButton(onPressed: () {
                        Navigator.of(context).pushNamed('/report_inappropriate', arguments:curReq);
                      },
                      child: Text("Report inappropriate"))
                  ]
                )
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
