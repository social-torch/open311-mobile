import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
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
  final String request_id;
  final String description;

  FeedbackInfo(
      this.account_id,
      this.request_id,
      this.description
      );

  Map<String, dynamic> toJson() =>
      {
        'type':'concern',
        'account_id': account_id,
        'request_id': request_id,
        'description': description
      };

  String toString() => "account_id: $account_id\nrequest_id: $request_id\ndescription: $description";
}

class ReportInappropriatePage extends Page {
  ReportInappropriatePage() : super(const Icon(Icons.email), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const ReportInappropriateBody();
  }
}

class ReportInappropriateBody extends StatefulWidget {
  const ReportInappropriateBody();

  @override
  State<StatefulWidget> createState() => ReportInappropriateState();
}

class ReportInappropriateState extends State<ReportInappropriateBody> {
  ReportInappropriateState();
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

  void showConfirmDialog(String msg) async {
    // flutter defined function
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Reporting"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void handleSendInappropriate(BuildContext context, String request_id, String feedback) async {
    Dio dio = new Dio();

    assert(() {
      //Using assert here for debug only prints
      print("USER FEEDBACK:"+feedback);
      return true;
    }());

    FeedbackInfo req = new FeedbackInfo(
        globals.userName,
        request_id,
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
        await showConfirmDialog("Thank you for your report. We will look into it.");
        //globals.popupMsg = "Thank you for your feedback, we will look into it.";
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
      showConfirmDialog("Unable to send feedback. Try again later");
      //globals.popupMsg = "Unable to send feedback. Try again later.";
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Requests req = ModalRoute.of(context).settings.arguments;
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
                          'Tell us your concerns:',
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
                            handleSendInappropriate(context, req.service_request_id, feedbackCtrl.text);
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


