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
  final String account_id;
  final String description;

  FeedbackInfo(
      this.account_id,
      this.description
      );

  Map<String, dynamic> toJson() =>
  {
    'account_id': account_id,
    'description': description
  };

  String toString() => "account_id: $account_id\ndescription: $description";
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

  void handleSendFeedback(BuildContext context, String feedback) async {
    Dio dio = new Dio();

    assert(() {
      //Using assert here for debug only prints
      print("USER FEEDBACK:"+feedback);
      return true;
    }());

    FeedbackInfo req = new FeedbackInfo(
        globals.userName,
        feedback
    );

    //Send post of user feedback to backend
    var endpoint = globals.endpoint311 + "/feedback";
    try {
      Response response;
      assert(() {
        //Using assert here for debug only prints
        print(req.toJson());
        return true;
      }());
      if (feedback.length > 0) {
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
        globals.popupMsg = "Thank you for your feedback.";
        Navigator.of(context).pop();
      } else {
        assert(() {
          //Using assert here for debug only prints
          print("No feedback entered");
          return true;
        }());
      }
    } catch(e) {
      print(e);
      globals.popupMsg = "Unable to send feedback. Try again later.";
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
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
                new Builder(builder:(context) {
                  return new ColorSliverButton(
                      onPressed: () {
                        handleSendFeedback(context, feedbackCtrl.text);
                      },
                      child:Text("Send"));
                })
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


