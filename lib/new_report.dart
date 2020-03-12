import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'page.dart';
import 'data.dart';
import 'location.dart';
import 'issue_type.dart';
import 'bottom_app_bar.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import "globals.dart" as globals;
import 'package:shared_preferences/shared_preferences.dart';

class NewReportPage extends Page {
  NewReportPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const NewReportBody();
  }
}

class NewReportBody extends StatefulWidget {
  const NewReportBody();

  @override
  State<StatefulWidget> createState() => NewReportBodyState();
}
          
class NewReportBodyState extends State<NewReportBody> {
  NewReportBodyState();

  bool _disableButtons = true;
  Timer enable_req_timer;
  
  void getImage(ImageSource source) async {
    await ImagePicker.pickImage(source: source,
                                maxWidth: 640,
                                maxHeight: 480).then((img) {
      ReportData().image = img;
    });
    if (ReportData().image != null)
    {
      locPage();
    }
  }

  void checkLastReqTime() async {
    if ( (enable_req_timer) != null && enable_req_timer.isActive) {
      enable_req_timer.cancel();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastReqTime = prefs.getString('lastReqTime') ?? "";
    if (lastReqTime == "") { //First request attempt, allow user to progress
      setState(() {
        _disableButtons = false;
      });
    } else {
      var ts = DateTime.parse(lastReqTime);
      var nextValidReqTime = ts.add(Duration(seconds: globals.sequentialReqDelay));
      if ( nextValidReqTime.isAfter(DateTime.now()) ) { 
        enable_req_timer = new Timer(nextValidReqTime.difference(DateTime.now()), () {
          setState(() {
            _disableButtons = false;
          });
        });
      } else {
        setState(() {
          _disableButtons = false;
        });
      }
    }
  }

  @override
  void initState() {
    if ( globals.isGuestUser()) { //Guest users can only submit after N seconds
      setState(() {
        _disableButtons = true; //Default to disabled and allow check to enable buttons
      });
      checkLastReqTime();
    } else { //Non-guest user, allow requests
      setState(() {
        _disableButtons = false;
      });
    }
    super.initState();
  }
 
  @override
  void dispose() {
    //Kill timer, it will get started again next time page is entered
    if (enable_req_timer != null) {
      enable_req_timer.cancel();
    }
    super.dispose();
  }

  void locPage() {
    //If we have made it to here, then it is time to select a location/address
    Navigator.of(context).pushNamed('/location');
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
                        'Select an Image',
                        textAlign: TextAlign.left,
                        textScaleFactor: 2.0,
                      ),
                    ),
                  ),
                  Container(height: 30.0),
                  _disableButtons ? 
                    Text("Guest users can only submit new requests every ${(globals.sequentialReqDelay/60).toInt()} minutes please try again later") : 
                    ProgressDots(
                      stage: 0,
                      numStages: 4,
                    ),
                  Container(height: 30.0),
                  ColorSliverButton(
                    onPressed: _disableButtons ? null : () => getImage(ImageSource.camera),
                    child: Row(
                      children: [
                        Image.asset("images/camera.png", height: 45.0,),
                        Text("    Camera"),
                    ],
                    ),
                  ),
                  Container(height: 15.0),
                  ColorSliverButton(
                    onPressed: _disableButtons ? null : () => getImage(ImageSource.gallery),
                    child: Row(
                      children: [
                        Image.asset("images/library.png", height: 45.0,),
                        Text("    Photo Library"),
                      ],
                    ),
                  ),
                  Container(height: 15.0),
                  ColorSliverButton(
                    onPressed: _disableButtons ? null : () {
                      ReportData().image = null;
                      locPage();
                    },
                    child: Row(
                      children: [
                        Image.asset("images/no_photo.png", height: 45.0,),
                        Text("    No Photo"),
                      ],
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
      ),
    );
  }
}
  
  
