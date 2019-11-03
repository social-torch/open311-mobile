import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import 'requests.dart';
import 'login.dart';
import "cities.dart";
import "utils.dart";
import "globals.dart" as globals;
import "custom_widgets.dart";
import "custom_colors.dart";
import "select_city_common.dart";
import "bottom_app_bar.dart";

class FeedbackInfo {
  final String type;
  final String username;
  final String description;
  final double lat;
  final double lon;
  final int timestamp;

  FeedbackInfo(
      this.type,
      this.username,
      this.description,
      this.lat,
      this.lon,
      this.timestamp
      );

  Map<String, dynamic> toJson() =>
  {
    'type': type,
    'username': username,
    'description': description,
    'lat':lat+0.0,
    'lon':lon+0.0,
    'timestamp': timestamp
  };

  String toString() => "type: $type username: $username loc: ($lat $lon) time:$timestamp\ndescription: $description";
}

class FeedbackPage extends Page {
  FeedbackPage() : super(const Icon(Icons.email), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const FeedbackBody();
  }
}

class FeedbackBody extends StatefulWidget {
  const FeedbackBody();

  @override
  State<StatefulWidget> createState() => FeedbackBodyState();
}

class FeedbackBodyState extends State<FeedbackBody> {
  FeedbackBodyState();
  TextField feedbackText;
  TextEditingController feedbackCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    feedbackText = TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter your feedback'
      ),
      controller: feedbackCtrl,
      minLines: 4,
      maxLines: 10,
      maxLength: 1024
    );

  }

  @override
  void dispose() {
    feedbackCtrl.dispose();
    super.dispose();
  }

  void handleSendFeedback(String feedback) async {
    Dio dio = new Dio();

    print("USER FEEDBACK:"+feedback);
    feedbackCtrl.text = 'Thank you for your feedback';

    FeedbackInfo req = new FeedbackInfo(
        "USERFEEDBACK",
        globals.userName,
        feedback,
        45.0,
        70.0,
        new DateTime.now().millisecondsSinceEpoch ~/ 1000);

    //Send post of user feedback to backend
    var endpoint = globals.endpoint311 + "/feedback";
    try {
      Response response;
      print(req.toJson());
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
    } catch(e) {
      print(e);
      feedbackCtrl.text = 'Unable to send request, try again later';
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
        automaticallyImplyLeading: false,
      ),
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
                      'Send us your thoughts:',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 10.0),
              feedbackText,
                Container(height: 10.0),
                ColorSliverButton(
                  onPressed: () {
                    handleSendFeedback(feedbackCtrl.text);
                  },
                    child:Text("Send"))
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


