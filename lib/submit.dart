import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'page.dart';
import 'data.dart';
import 'bottom_app_bar.dart';

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

  void _apiGateway() async
  {
    try {
      Response response;
      Dio dio = new Dio();
      response = await dio.get("http://www.google.com");
      print(response.data);
    } catch (e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: AppBar(title: Text(APP_NAME)),
      bottomNavigationBar: commonBottomBar(context),
      body: new ListView(
        children: [
          new Column(
            children: <Widget>[
              new Text(
                '${ReportData()}',
              ),
              new RaisedButton(
                onPressed: () {
                    _apiGateway();
                    //Navigator.popUntil(context, ModalRoute.withName("/home"));
                },
                child: new Text( 
                "Submit", 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
