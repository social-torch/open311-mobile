import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import 'login.dart';
import "cities.dart";
import "utils.dart";
import "globals.dart" as globals;
import "custom_widgets.dart";
import "custom_colors.dart";
import "select_city_common.dart";
import "bottom_app_bar.dart";

class SelectCityPage extends Page {
  SelectCityPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const SelectCityBody();
  }
}

class SelectCityBody extends StatefulWidget {
  const SelectCityBody();

  @override
  State<StatefulWidget> createState() => SelectCityBodyState();
}

class SelectCityBodyState extends State<SelectCityBody> {
  SelectCityBodyState();

  Widget _bodyWidget;

  //This function will only run if user has already chosen a default city
  initNav(context) {
    if (globals.endpoint311 != 'nada') {
      //This is a bit of a hack but force bottom app bar to change color appropriately
      navPage = "/all_reports";
      Navigator.of(context).pushReplacementNamed('/all_reports');
    }
  }

  //Get city to use to determine endpoint calls, unless a default already exists
  Widget _getBody(BuildContext context) {
    Widget retval = Text("Loading available cities...");
    if (_bodyWidget != null) {
      retval = _bodyWidget;
    }
    return retval;
  }

  Future<Widget> getBodyText() async {
    Widget retval;
    final Dio dio = Dio();
    try {
      Response response = await dio.get(
        globals.endpoint311base + "/cities",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: globals.userIdToken
          },
        ),
      );
      CityData().cities_resp = CitiesResponse.fromJson(response.data);
      assert(() {
        //Using assert here for debug only prints
        print(response.data);
        return true;
      }());
      //This is a bit of a hack but force bottom app bar to change color appropriately
      navPage = "/all_reports";
      retval = setMyCity(context, "/all_reports");
    } catch (error, stacktrace) {
      assert(() {
        //Using assert here for debug only prints
        print("Exception occured: $error stackTrace: $stacktrace");
        return true;
      }());
      //This is a poor mans threadish way to doing processing on the side without deadlocking async
      compute(sleepThread, 1).then((num) {
        getBodyText().then((wdgt) {
          //This is a bit odd, but since this is part of compute it will never return,
          // but we can set state and get the effect we want anyway.
          if (wdgt != null) {
            setState(() {
              _bodyWidget = wdgt;
            });
          }
        });
      });
    }

    return retval;
  }  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initNav(context));

    if (globals.endpoint311 == 'nada') {
      getBodyText().then((newBodyWidget) {
        setState(() {
          _bodyWidget = newBodyWidget;
        });
      });
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
                      'Choose your city:',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 30.0),
                _getBody(context),
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


