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
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 's3endpoint.dart';

class UpdateReportImgPage extends Page {
  UpdateReportImgPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const UpdateReportImgBody();
  }
}

class UpdateReportImgBody extends StatefulWidget {
  const UpdateReportImgBody();

  @override
  State<StatefulWidget> createState() => UpdateReportImgBodyState();
}
          
class UpdateReportImgBodyState extends State<UpdateReportImgBody> {
  UpdateReportImgBodyState();

  void getImage(ImageSource source) async {
    await ImagePicker.pickImage(source: source,
                                maxWidth: 640,
                                maxHeight: 480).then((img) {
      ReportData().image = img;
    });
    if (ReportData().image != null)
    {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                      'Update Data',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
                  ),
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


