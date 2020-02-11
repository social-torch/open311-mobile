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

  void reqPage() async {
    try {
      Dio dio = new Dio();

      //If we have a new image to upload, upload it
      String media_url = UpdateData().req.media_url;
      if (ReportData().image != null) {
        if (UpdateData().req.media_url == "") {  //No original image, get a new media_url
          var uuid = new Uuid();
          media_url = uuid.v4() + p.extension(ReportData().image.path);
        }

        Response s3rep = await dio.get(
          globals.endpoint311base + "/images/store/" + media_url,
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: globals.userIdToken
            },
          ),
        );
        //Parse out url
        S3endpoint s3ep = S3endpoint.fromJson(s3rep.data);
          
        //Now that we have url and shrunk the input image, send image
        var put_resp = await http.put(
          s3ep.url,
          body: ReportData().image.readAsBytesSync(),
          headers: {"Content-Type": "image/" + media_url.split(".").last}
        );
      }

      UpdateData().req.status_notes = descController.text;

      //Send post of user request to backend
      var endpoint = globals.endpoint311 + "/request";
      Response response;
      response = await dio.post(
        endpoint,
        data: UpdateData().req.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: globals.userIdToken,
            HttpHeaders.fromHeader: globals.userName
          },
        ),
      );
      assert(() {
        //Using assert here for debug only prints
        print(response.data);
        print(response.headers);
        print(response.request);
        return true;
      }());
      getRequests(globals.endpoint311 + "/requests");
    } catch (e) {
      print(e);
    }
    Navigator.of(context).pop();
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
    );
  } 
}


