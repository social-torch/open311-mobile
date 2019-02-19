import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'description.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'bottom_app_bar.dart';


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

  Color _getStatusColor(status) {
    var retval = CustomColors.salmon;
    if (status == "closed") {
      retval = CustomColors.appBarColor;
    }
    return retval;
  }

  Widget _getImg() {
    Widget retval =  image: new Image.network( 
      CityData().req_resp.requests[CityData().prevReqIdx].media_url,
      fit: BoxFit.cover,
      height: double.infinity,
      width: (MediaQuery.of(context).size.width * 0.5) - 36.0,
      alignment: Alignment.center,
    ),
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
                    Column(
                      children: [
                        Text(CityData().req_resp.requests[Index].service_name),
                        Text(CityData().req_resp.requests[Index].requested_datetime),
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
