import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'page.dart';
import 'data.dart';
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
    if (CityData().req_resp.requests[CityData().prevReqIdx].media_url ?? "" != "") {
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
          fit: BoxFit.cover,
          height: (MediaQuery.of(context).size.width * 0.5) - 39.0,
          width: (MediaQuery.of(context).size.width * 0.5) - 39.0,
          alignment: Alignment.center,
        );
      } catch(e) {
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
    if (CityData().req_resp.requests[CityData().prevReqIdx].media_url ?? "" == "") {
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
                  color: Colors.grey,
                ),
              ),
            ),
            Positioned.fill(
                child: new Column(children: [
                  Image.asset("images/blank_image.png"),
                  Text("No image available")])
            )
            /*,
            Positioned(
              child: GestureDetector(
                onTap: () {
                  CityData().itemSelected = true;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "/all_reports", ModalRoute.withName("/nada"));
                },
                child: _getValidImg(context),
              ),
            ),*/
          ]
      );
      return retval;
    } else {
      Widget retval = new Stack(children:[Text("Loading")]);

      return retval;
    }
  }

  Widget _getProgressList() {

    //Create progress blurbs from datetime information and status from backend [open, accepted, inProgress, closed]
    List<List<String> > status = new List<List<String> >();
    List<String> date_stat_descript = new List<String>();
    date_stat_descript.add(getTimeString(CityData().req_resp.requests[CityData().prevReqIdx].requested_datetime));
    date_stat_descript.add("Issue Submitted");
    String desc = "N/A";
    if (CityData().req_resp.requests[CityData().prevReqIdx].description != "") {
      desc = CityData().req_resp.requests[CityData().prevReqIdx].description;
    }
    date_stat_descript.add("Description: " + desc);

    status.add(new List<String>.from(date_stat_descript));
    
    date_stat_descript.clear();
    if ( (CityData().req_resp.requests[CityData().prevReqIdx].update_datetime != "") && 
         ( (CityData().req_resp.requests[CityData().prevReqIdx].status == "open") || 
           (CityData().req_resp.requests[CityData().prevReqIdx].status == "inProgress") || 
           (CityData().req_resp.requests[CityData().prevReqIdx].status == "closed")) 
       ) {
      date_stat_descript.add(getTimeString(CityData().req_resp.requests[CityData().prevReqIdx].update_datetime));
      date_stat_descript.add("Issue Received");
      if (CityData().req_resp.requests[CityData().prevReqIdx].status == "open") {
        String s_notes = "N/A";
        if (CityData().req_resp.requests[CityData().prevReqIdx].status_notes != "") {
          s_notes = CityData().req_resp.requests[CityData().prevReqIdx].status_notes;
        }
        date_stat_descript.add("Status Notes: " + s_notes);
      }
      if ( CityData().req_resp.requests[CityData().prevReqIdx].expected_datetime != "" ) {
        date_stat_descript.add("Thank you for submitting your service request. Your issue has been received by the city and is scheduled to be resolved starting " + getTimeString(CityData().req_resp.requests[CityData().prevReqIdx].expected_datetime) + ".");
      }
      else
      {
        date_stat_descript.add("Thank you for submitting your service request. Your issue has been received by the city. You will receive a notification when the request has been addressed by the servicing agency.");
      }
    }
    if ( (CityData().req_resp.requests[CityData().prevReqIdx].update_datetime != "") && 
         ( (CityData().req_resp.requests[CityData().prevReqIdx].status == "inProgress") || 
           (CityData().req_resp.requests[CityData().prevReqIdx].status == "closed") ) )  {
      date_stat_descript.add(getTimeString(CityData().req_resp.requests[CityData().prevReqIdx].update_datetime));
      date_stat_descript.add("Issue In Progress");
      if (CityData().req_resp.requests[CityData().prevReqIdx].status == "inProgress") {
        String s_notes = "N/A";
        if (CityData().req_resp.requests[CityData().prevReqIdx].status_notes != "") {
          s_notes = CityData().req_resp.requests[CityData().prevReqIdx].status_notes;
        }
        date_stat_descript.add("Status Notes: " + s_notes);
      }
      date_stat_descript.add("This issue resolution is in progress");
    }
    if ( (CityData().req_resp.requests[CityData().prevReqIdx].update_datetime != "") && 
         (CityData().req_resp.requests[CityData().prevReqIdx].status == "closed") )  {
      date_stat_descript.add(getTimeString(CityData().req_resp.requests[CityData().prevReqIdx].update_datetime));
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
                      'Request Details',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
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
                              CityData().req_resp.requests[CityData().prevReqIdx].service_name + " " + getBasicAddress(CityData().req_resp.requests[CityData().prevReqIdx].address),
                              textScaleFactor: 1.2,
                            ),
                          ),
                          Container(height: 10.0),
                          Text(
                            getTimeString(CityData().req_resp.requests[CityData().prevReqIdx].requested_datetime),
                            textScaleFactor: 1.0,
                          ),
                          Container(height: 10.0),
                          Container(
                            width: DeviceData().ButtonHeight * 1.5,
                            height: DeviceData().ButtonHeight * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                color: getStatusColor(CityData().req_resp.requests[CityData().prevReqIdx].status),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  CityData().req_resp.requests[CityData().prevReqIdx].status,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ]
                            ),
                          ),
                        ]
                      ),
                    ),
                  ]
                ),
                Container(height: 30.0),
                Expanded(
                  child: _getProgressList(),
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
