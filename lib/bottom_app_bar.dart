import 'package:flutter/material.dart';
import 'new_report.dart';
import 'view_submitted_user.dart';
import 'all_reports.dart';
import 'settings.dart';
import 'custom_colors.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'authenticate.dart';

String navPage = "nada";
String basePage = "/nada"; //No base page, but maybe someday there will be?

Color _currentPageColor(currentPage) {
  if (navPage == currentPage) {
    return CustomColors.salmon;
  }
  return Colors.black;
}

FontWeight _currentPageBold(currentPage) {
  if (navPage == currentPage) {
    return FontWeight.bold;
  }
  return FontWeight.normal;
}

String _logInOrOut() {
  String retval = "Log In";
  if (globals.userName != globals.guestName) {
    retval = "Log Out";
  }
  return retval;
}

void resetPersistentData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userName', "");
  await prefs.setString('userPass', "");
}

Widget commonBottomBar(context) {
  return BottomAppBar(
    child: new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Image.asset("images/add new.png", color: _currentPageColor("/new_report")),
                  color: _currentPageColor("/new_report"),
                  highlightColor: CustomColors.salmon,
                  tooltip: 'Submit a new report',
                  onPressed: () {
                    var newPage = "/new_report";
                    if (navPage != newPage) {
                      navPage = newPage;
                      Navigator.of(context).pushNamedAndRemoveUntil(newPage, ModalRoute.withName(basePage));
                    }
                  }
              ),
              Text(
                "Create",
                style: TextStyle(
                  color: _currentPageColor("/new_report"),
                  fontWeight: _currentPageBold("/new_report"),
                ),
              ),
            ]
        ),
        Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Image.asset("images/add view requests.png", color: _currentPageColor("/view_submitted_user")),
                  color: _currentPageColor("/view_submitted_user"),
                  highlightColor: CustomColors.salmon,
                  tooltip: 'View your past submissions',
                  onPressed: () {
                    var newPage = "/view_submitted_user";
                    if (navPage != newPage) {
                      navPage = newPage;
                      Navigator.of(context).pushNamedAndRemoveUntil(newPage, ModalRoute.withName(basePage));
                    }
                  }
              ),
              Text(
                "Requests",
                style: TextStyle(
                  color: _currentPageColor("/view_submitted_user"),
                  fontWeight: _currentPageBold("/view_submitted_user"),
                ),
              ),
            ]
        ),
        Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Image.asset("images/map.png", color: _currentPageColor("/all_reports")),
                  color: _currentPageColor("/all_reports"),
                  highlightColor: CustomColors.salmon,
                  tooltip: 'Map of all reports',
                  onPressed: () {
                    var newPage = "/all_reports";
                    if (navPage != newPage) {
                      navPage = newPage;
                      Navigator.of(context).pushNamedAndRemoveUntil(newPage, ModalRoute.withName(basePage));
                    }
                  }
              ),
              Text(
                "Map",
                style: TextStyle(
                  color: _currentPageColor("/all_reports"),
                  fontWeight: _currentPageBold("/all_reports"),
                ),
              ),
            ]
        ),
        Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Image.asset("images/settings_info.png", color: _currentPageColor("/settings")),
                  color: _currentPageColor("/settings"),
                  highlightColor: CustomColors.salmon,
                  tooltip: 'View your current settings',
                  onPressed: () {
                    var newPage = "/settings";
                    if (navPage != newPage) {
                      navPage = newPage;
                      Navigator.of(context).pushNamedAndRemoveUntil(newPage, ModalRoute.withName(basePage));
                    }
                  }
              ),
              Text(
                "Settings & Help",
                style: TextStyle(
                  color: _currentPageColor("/settings"),
                  fontWeight: _currentPageBold("/settings"),
                ),
              ),
            ]
        ),
        Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Image.asset("images/login.png", color: _currentPageColor("/login")),
                  color: _currentPageColor("/login"),
                  highlightColor: CustomColors.salmon,
                  tooltip: _logInOrOut(),
                  onPressed: () async {
                    if (_logInOrOut() == "Log Out") {
                      bool noAskLogout = false;
                      await showDialog<int>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Confirm Logout"),
                            content: new Column(
                              children: <Widget>[
                                Text("Are you sure you want to logout?")
                                /*,Row( children: <Widget> [
                                  Text("Don't ask again"),
                                  CheckboxListTile(
                                      title: const Text("Don't ask again"),
                                      value: false,
                                      onChanged: (bool value) {
                                        noAskLogout = value;
                                  })
                                ]
                                )*/
                            ]),
                            actions: <Widget>[
                              new FlatButton(
                                child:new Text("Cancel"),
                                onPressed: () {
                                Navigator.of(context).pop(0);
                              }),
                              new FlatButton(
                                child: new Text("Ok"),
                                onPressed: () {
                                  Navigator.of(context).pop(1);
                                }
                              )
                            ]
                          );
                        }
                      ).then((shouldLogout) {
                        print("Don't ask logout: $noAskLogout");
                        if (shouldLogout == 1) {
                          //Log out user, go back to as if app is first starting.
                          basePage = 'nada';
                          navPage = '/nada';
                          globals.endpoint311 = 'nada';
                          globals.userName = globals.guestName;
                          globals.userPass = globals.guestPass;

                          //Remove saved info from persistent store
                          resetPersistentData();

                          //Login as guest
                          authenticate();

                          Navigator.of(context).pushReplacementNamed('/select_city');
                        }
                      });


                    } else {
                      var newPage = "/login";
                      if (navPage != newPage) {
                        navPage = newPage;
                        Navigator.of(context).pushNamedAndRemoveUntil(newPage, ModalRoute.withName(basePage));
                      }
                    }
                  }
              ),
              Text(
                _logInOrOut(),
                style: TextStyle(
                  color: _currentPageColor("/login"),
                  fontWeight: _currentPageBold("/login"),
                ),
              ),
            ]
        ),
      ],
    ),
  );
}
