import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'data.dart';
import 'services.dart';
import 'requests.dart';
import 'users.dart';
import "globals.dart" as globals;
import "custom_widgets.dart";
import "custom_colors.dart";
import 'utils.dart';

Future<int> getUsers(endpoint) async {
  final Dio dio = Dio();
  int retval = 0;
  try {
    retval++;
    Response response = await dio.get(
      endpoint,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: globals.userIdToken
        },
      ),
    );
    if ( response.data.toString().substring(0,9) != "Not Found" ) {
      CityData().users_resp = Users.fromJson(response.data);
    }
  } catch (error, stacktrace) {
    assert(() {
      //Using assert here for debug only prints
      print("getUsers($endpoint) Exception occured: $error stackTrace: $stacktrace");
      return true;
    }());
    //This is a poor mans threadish way to doing processing on the side without deadlocking async
    compute(sleepThread, 1).then((num) { 
      getUsers(endpoint).then((cnt) { retval += cnt; });
    });
  }
  return retval;
}

Future<int> getServices(endpoint) async {
  final Dio dio = Dio();
  int retval = 0;
  try {
    retval++;
    Response response = await dio.get(
      endpoint,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: globals.userIdToken
        },
      ),
    );

    CityData().serv_resp = ServicesResponse.fromJson(response.data);
  } catch (error, stacktrace) {
    assert(() {
      //Using assert here for debug only prints
      print("getServices($endpoint) Exception occured: $error stackTrace: $stacktrace");
      return true;
    }());
    //This is a poor mans threadish way to doing processing on the side without deadlocking async
    compute(sleepThread, 1).then((num) { 
      getServices(endpoint).then((cnt) { retval += cnt; });
    });
  }
  return retval;
}

Future<int> getRequests(endpoint) async {
  final Dio dio = Dio();
  int retval = 0;
  try {
    retval++;
    Response response = await dio.get(
      endpoint,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: globals.userIdToken
        },
      ),
    );
    //print(response.data);
    CityData().req_resp = RequestsResponse.fromJson(response.data);

    //For guest user we only show latest 25 items, lets filter them out now.
    RequestsResponse req_resp = RequestsResponse.fromJson(response.data);
    // Sort req_resp using datetime compare, take top 25
    while(req_resp.requests.length > 25)
    {
      var oldestIdx = 0;
      for (var i=1; i<req_resp.requests.length; i++)
      {
        if (getLatestDateString(req_resp.requests[oldestIdx].requested_datetime, req_resp.requests[i].requested_datetime) == req_resp.requests[oldestIdx].requested_datetime)
        {
          oldestIdx = i;
        }
      }
      req_resp.requests.removeAt(oldestIdx);
    }
    CityData().limited_req_resp = req_resp;
  } catch (error, stacktrace) {
    assert(() {
      //Using assert here for debug only prints
      print("getRequests($endpoint) Exception occured: $error stackTrace: $stacktrace");
      return true;
    }());

    //This is a poor mans threadish way to doing processing on the side without deadlocking async
    compute(sleepThread, 1).then((num) {
      getRequests(endpoint).then((cnt) { retval += cnt; });
    });
  }
}

Widget setMyCity(BuildContext context, String nextPage) {
  return Expanded( 
    child: new ListView.builder (
      itemCount: CityData().cities_resp.cities.length,
      itemBuilder: (BuildContext context, int Index) {
        return new Column(
          children: [
            new ColorSliverButton(
              child: Text(CityData().cities_resp.cities[Index].city_name),
              onPressed: () {
                globals.endpoint311 = CityData().cities_resp.cities[Index].endpoint;
                globals.cityIdx = Index;
                getServices(globals.endpoint311 + "/services");
                getRequests(globals.endpoint311 + "/requests");
                getUsers(globals.endpoint311 + "/user/" + globals.userName);
                Navigator.of(context).pushNamedAndRemoveUntil(nextPage, ModalRoute.withName("/nada"));
              },
            ),
            Container(height: 15.0),
          ]
        );
      },
    ),
  );
}
