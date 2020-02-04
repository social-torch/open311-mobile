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
import 'package:dio/dio.dart';
import 'select_city_common.dart';
import 'package:http/http.dart' as http;


class UpdateReportPage extends Page {
  UpdateReportPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const UpdateReportBody();
  }
}

class UpdateReportBody extends StatefulWidget {
  const UpdateReportBody();

  @override
  State<StatefulWidget> createState() => UpdateReportBodyState();
}
          
class UpdateReportBodyState extends State<UpdateReportBody> {
  UpdateReportBodyState();

  final descController = TextEditingController();

  void getImage(ImageSource source) async {
    await ImagePicker.pickImage(source: source,
                                maxWidth: 640,
                                maxHeight: 480).then((img) {
      ReportData().image = img;
    });
    if (ReportData().image != null)
    {
      reqPage();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  void reqPage() {
    //TODO: update request here
//    var put_resp = await http.put(
//      UpdateData().req.media_url,
//      body: ReportData().image.readAsBytesSync(),
//      headers: {"Content-Type": "image/jpeg"}
//    );
//    UpdateData().req.status_notes = descController.text;
//
//    //Send post of user request to backend
//      var endpoint = globals.endpoint311 + "/request";
//      Response response;
//      response = await dio.post(
//        endpoint,
//        data: ReportData().req.toJson(),
//        options: Options(
//          headers: {
//            HttpHeaders.authorizationHeader: globals.userIdToken,
//            HttpHeaders.fromHeader: globals.userName
//          },
//        ),
//      );
//      assert(() {
//        //Using assert here for debug only prints
//        print(response.data);
//        print(response.headers);
//        print(response.request);
//        return true;
//      }());
//      getRequests(globals.endpoint311 + "/requests");

    Navigator.of(context).pop();
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
                        'Status Update',
                        textAlign: TextAlign.left,
                        textScaleFactor: 2.0,
                      ),
                    ),
                  ),
                  Container(height: 30.0),
                  ColorSliverTextField(
                    maxLines: 6,
                    controller: descController,
                    labelText: 'Write an optional status update here'
                  ),
                  Container(height: 15.0),
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
                  Row(
                    children: [
                      FlatButton(
                        color: CustomColors.appBarColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                        textColor: Colors.white,
                        onPressed: reqPage,
                        child: Text( "Update"),
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
      ),
    );
  }
}
  
  
