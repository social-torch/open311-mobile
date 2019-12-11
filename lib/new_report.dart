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

  @override
  void initState() {
    super.initState();
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
                  ProgressDots(
                    stage: 0,
                    numStages: 4,
                  ),
                  Container(height: 30.0),
                  ColorSliverButton(
                    onPressed: () { getImage(ImageSource.camera); },
                    child: Row(
                      children: [
                        Image.asset("images/camera.png", height: 45.0,),
                        Text("    Camera"),
                    ],
                    ),
                  ),
                  Container(height: 15.0),
                  ColorSliverButton(
                    onPressed: () { getImage(ImageSource.gallery); },
                    child: Row(
                      children: [
                        Image.asset("images/library.png", height: 45.0,),
                        Text("    Photo Library"),
                      ],
                    ),
                  ),
                  Container(height: 15.0),
                  ColorSliverButton(
                    onPressed: () {
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
  
  
