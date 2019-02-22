import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'description.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'bottom_app_bar.dart';
import 'utils.dart';


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

  @override
  void initState() {
    super.initState();
  }

  Widget _getValidImg() {
    Widget retval = new Text("");
    if (CityData().req_resp.requests[CityData().prevReqIdx].media_url != "") {
      retval = new Image.network(
        CityData().req_resp.requests[CityData().prevReqIdx].media_url,
        fit: BoxFit.cover,
        height: (MediaQuery.of(context).size.width * 0.5) - 39.0,
        width: (MediaQuery.of(context).size.width * 0.5) - 39.0,
        alignment: Alignment.center,
      );
    }
    return retval;
  }
  
  Widget _getImg() {
    Widget retval = new Stack(
      children: [
        Container(
          height: (MediaQuery.of(context).size.width * 0.5) - 39.0,
          width: (MediaQuery.of(context).size.width * 0.5) - 39.0,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
        Positioned(
          bottom: ((MediaQuery.of(context).size.width * 0.5) - 39.0)/2.0,
          child: Text("No image available"),
        ),
        Positioned(
          child: _getValidImg(),
        ),
      ]
    );
    return retval;
  }

  Widget _getProgressList() {

    //Create progress blurbs from datetime information and status from backend
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
    if ( (CityData().req_resp.requests[CityData().prevReqIdx].update_datetime != "") && (CityData().req_resp.requests[CityData().prevReqIdx].status == "open") ) {
      date_stat_descript.add(getTimeString(CityData().req_resp.requests[CityData().prevReqIdx].update_datetime));
      date_stat_descript.add("Issue Received");
      if ( CityData().req_resp.requests[CityData().prevReqIdx].expected_datetime != "" ) {
        date_stat_descript.add("Thank you for submitting your service request. Your issue has been received by the city and is scheduled to be resolved starting " + getTimeString(CityData().req_resp.requests[CityData().prevReqIdx].expected_datetime) + ".");
      }
      else
      {
        date_stat_descript.add("Thank you for submitting your service request. Your issue has been received by the city. You will receive a notification when the request has been addressed by the servicing agency.");
      }
    }
    else if ( (CityData().req_resp.requests[CityData().prevReqIdx].update_datetime != "") && (CityData().req_resp.requests[CityData().prevReqIdx].status == "closed") ) {
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
                      'Submitted Service Requests',
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
