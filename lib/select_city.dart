import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import 'login.dart';
import "cities.dart";
import "services.dart";
import "requests.dart";
import "globals.dart" as globals;
import "custom_widgets.dart";
import "custom_colors.dart";
import "select_city_common.dart";


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
      Navigator.of(context).pushReplacementNamed('/my_homepage');
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
    
    final Dio dio = Dio();
    try {
      Response response = await dio.get(globals.endpoint311base + "/cities");
      CityData().cities_resp = CitiesResponse.fromJson(response.data);
      assert(() {
        //Using assert here for debug only prints
        print(response.data);
        return true;
      }());
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }

    Widget retval = new Text("Got the data");
    return retval;
  }  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initNav(context));

    getBodyText().then((newBodyWidget) {
      setState(() {
        _bodyWidget = newBodyWidget;
      });
    });
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


