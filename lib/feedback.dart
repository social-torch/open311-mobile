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

    Requests req = new Requests(
        "",
        "",
        "",
        "USERFEEDBACK",
        "SC-8a28ff0d-b954-4f56-aad0-83397db49a4e",
        "FEEDBACK:"+feedback,
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        0,
        45.0,
        70.0,
        "feedback lane");

    //Send post of user feedback to backend
    var endpoint = globals.endpoint311 + "/request";
    try {
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


