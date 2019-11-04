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
  final SnackBar successSnackBar = SnackBar(content: Text('Thank you for your feedback'));
  final SnackBar failureSnackBar = SnackBar(content: Text('Unable to send feedback. Try again later.'));
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

    print("USER FEEDBACK:"+feedback);

    FeedbackInfo req = new FeedbackInfo(
        globals.userName,
        feedback
    );

    //Send post of user feedback to backend
    var endpoint = globals.endpoint311 + "/feedback";
    try {
      Response response;
      print(req.toJson());
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
        Scaffold.of(context).showSnackBar(successSnackBar);
      } else {
        print("No feedback entered");
      }
    } catch(e) {
      print(e);
      Scaffold.of(context).showSnackBar(failureSnackBar);
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


