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
    Navigator.of(context).pushNamed('/view_submitted_item');
  }

  Color _getStatusColor(status) {
    var retval = CustomColors.salmon;
    if (status == "closed") {
      retval = CustomColors.appBarColor;
    }
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
                Expanded(
                  child: new ListView.builder (
                    itemCount: CityData().req_resp.requests.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return  new ColorSliverButton(
                        onPressed: () {
                          ReportData().type = CityData().req_resp.requests[Index].service_name;
                          CityData().prevReqIdx = Index;
                          nextPage();
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(CityData().req_resp.requests[Index].service_name),
                                Row(
                                  children: [
                                    Text(CityData().req_resp.requests[Index].requested_datetime),
                                    Container(
                                      width: 15.0,
                                    ),
                                    Container(
                                      width: DeviceData().ButtonHeight * 1.5,
                                      height: DeviceData().ButtonHeight * 0.4,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                          color: _getStatusColor(CityData().req_resp.requests[Index].status),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            CityData().req_resp.requests[Index].status,
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
