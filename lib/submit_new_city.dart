import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'page.dart';
import 'data.dart';
import 'login.dart';
import 'requests.dart';
import 's3endpoint.dart';
import 'bottom_app_bar.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'select_city_common.dart';
import "globals.dart" as globals;

class SubmitNewCityPage extends Page {
  SubmitNewCityPage() : super(const Icon(Icons.map), 'SubmitNewCity Report');

  @override
  Widget build(BuildContext context) {
    return const SubmitNewCityBody();
  }
}

class SubmitNewCityBody extends StatefulWidget {
  const SubmitNewCityBody();

  @override
  State<StatefulWidget> createState() => SubmitNewCityBodyState();
}

class SubmitNewCityBodyState extends State<SubmitNewCityBody> {
  SubmitNewCityBodyState();

  Widget _bodyWidget;

  Widget successBody() {
    return new Expanded(
      child: Column(
        children: [
          Container(height: 30.0),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Text(
                'Your new city request has been submitted',
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
                'Your new city request was unsuccessful',
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
        ]
      ),
    );
  }

  Future<Widget> getBodyFuture() async {
    Widget retval;
    try {
      Dio dio = new Dio();

      assert(() {
        // Inside assert for debug only printing
        print(CityData().rac_resp.toJson());
      }());

      //Send post of user request to backend
      var endpoint = globals.endpoint311base + "/feedback";
      Response response;
      response = await dio.post(
        endpoint,
        data: CityData().rac_resp.toJson(),
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
    } catch (e) {
      print(e);
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
    Widget retval = Text("Submitting New City Request...");
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
      ),
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
