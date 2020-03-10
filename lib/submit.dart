import 'dart:io';
import 'package:image/image.dart' as imagelib;
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'page.dart';
import 'data.dart';
import 'login.dart';
import 'reg_page.dart';
import 'requests.dart';
import 's3endpoint.dart';
import 'bottom_app_bar.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'select_city_common.dart';
import "globals.dart" as globals;
import 'package:shared_preferences/shared_preferences.dart';

class SubmitPage extends Page {
  SubmitPage() : super(const Icon(Icons.map), 'Submit Report');

  @override
  Widget build(BuildContext context) {
    return const SubmitBody();
  }
}

class SubmitBody extends StatefulWidget {
  const SubmitBody();

  @override
  State<StatefulWidget> createState() => SubmitBodyState();
}

class SubmitBodyState extends State<SubmitBody> {
  SubmitBodyState();

  Widget _bodyWidget;

  Widget submitAnotherRequest() {
    return RichText(
      text: new TextSpan (
        children: [
          new TextSpan(
            text: "Report another issue",
            style: new TextStyle(color: Colors.blue),
            recognizer: new TapGestureRecognizer()
            ..onTap = () {
              Navigator.of(context).pushNamed('/new_report');
            },
          ),
        ],
      )
    );
  }

  Widget successBody() {
    return new Expanded(
      child: Column(
        children: [
          Container(height: 30.0),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Text(
                'Your service request has been submitted',
                textAlign: TextAlign.center,
                textScaleFactor: 2.0,
              ),
            ),
          ),
          Container(height: 30.0),
          SizedBox(
            width: 2 * DeviceData().ButtonHeight,
            child: Image.asset('images/confirmation.png'),
          ),
          Container(height: 30.0),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Text(
                'Thank you for your submission.',
                textAlign: TextAlign.center,
                textScaleFactor: 1.0,
              ),
            ),
          ),
          Container(height: 30.0),
          submitAnotherRequest(),
        ]
      ),
    );
  }

  Widget failedBody() {
    return new Expanded(
      child: Column(
        children: [
          Container(height: 30.0),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Text(
                'Your service request was unsuccessful',
                textAlign: TextAlign.center,
                textScaleFactor: 2.0,
              ),
            ),
          ),
          Container(height: 30.0),
          SizedBox(
            width: 2 * DeviceData().ButtonHeight,
            child: Image.asset('images/failed.png'),
          ),
          Container(height: 30.0),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Text(
                'Please try again at a later time.',
                textAlign: TextAlign.center,
                textScaleFactor: 1.0,
              ),
            ),
          ),
          Container(height: 30.0),
          submitAnotherRequest(),
        ]
      ),
    );
  }

  Future<Widget> getBodyFuture() async {
    Widget retval;
    try {
      Dio dio = new Dio();

      //Get s3 url we can send image to if applicable
      String media_url = "";
      if (ReportData().image != null) {
        var uuid = new Uuid();
        media_url = uuid.v4() + p.extension(ReportData().image.path);

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

        //shrink image
        //imagelib.Image img = imagelib.decodeImage(ReportData().image.readAsBytesSync());
        //imagelib.Image shrunk = imagelib.copyResize(img, 1024);
          //body: imagelib.encodeNamedImage(shrunk, media_url),

        //Now that we have url and shrunk the input image, send image
        var put_resp = await http.put(
          s3ep.url,
          body: ReportData().image.readAsBytesSync(),
          headers: {"Content-Type": "image/" + media_url.split(".").last}
        );
      }

      //Populate our request with user data
      var ae = new List.filled(1, AuditEntry("Test", "", ""));
      Requests req = new Requests(
        "",
        "",
        "",
        ReportData().type,
        ReportData().type_code,
        ReportData().description,
        "",
        "",
        "",
        "",
        "",
        "",
        ReportData().addr,
        0,
        ReportData().latlng.latitude, 
        ReportData().latlng.longitude, 
        media_url,
        new AuditEntries(ae, ""));


      //Send post of user request to backend
      var endpoint = globals.endpoint311 + "/request";
      Response response;
      response = await dio.post(
        endpoint,
        data: req.toJson(),
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
      retval = successBody();
      //For guests log request time since we limit how often they can submit
      if (globals.userName == globals.guestName) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('lastReqTime', DateTime.now().toUtc().toString());
      }
      getRequests(globals.endpoint311 + "/requests");
      getUsers(globals.endpoint311 + "/user/" + globals.userName);
    } catch (e) {
      print(e);
      print(e.response.data);
      retval = failedBody();
    }
    return retval;
  }

  @override
  void initState() {
    super.initState();
    getBodyFuture().then((newBodyWidget) {
      setState(() {
        _bodyWidget = newBodyWidget;
      });
    });
  }

  Widget _getBody(BuildContext context) {
    Widget retval = Text("Submitting Request...");
    if(_bodyWidget != null) {
      retval = _bodyWidget;
    }
    return retval;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: commonBottomBar(context),
      body: Row (
        children: [
          Container(
            width: 36.0,
          ),
          _getBody(context),
          Container(
            width: 36.0,
          ),
        ]
      ),
    );
  }
}
