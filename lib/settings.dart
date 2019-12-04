import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'location.dart';
import 'bottom_app_bar.dart';
import 'custom_colors.dart';
import 'custom_widgets.dart';
import "globals.dart" as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SettingsPage extends Page {
  SettingsPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const SettingsBody();
  }
}

class LogInOutSettings {
  bool autoLogin;
  bool askLogout;

  LogInOutSettings({ this.autoLogin = true,  this.askLogout = true });
}

class SettingsBody extends StatefulWidget {
  const SettingsBody();

  @override
  State<StatefulWidget> createState() => SettingsBodyState();
}
          
class SettingsBodyState extends State<SettingsBody> {
  SettingsBodyState();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  LogInOutSettings lioSet = LogInOutSettings();

  Future<LogInOutSettings> _getInitialAutoLogInOutState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool autoLogIn = prefs.getBool('autoLogIn') ?? true;
    bool askLogout = prefs.getBool('askLogout') ?? true ;
    LogInOutSettings lioSettings = LogInOutSettings(autoLogin: autoLogIn, askLogout: askLogout);
    return lioSettings;
  }

  @override
  void initState() {
    super.initState();
    _getInitialAutoLogInOutState().then((value) {
      setState(() {
        lioSet = value;
      });
    });
  }

  /// Stores the user preference for confirming if the user should logout.
  void _setAskLogoutSetting(bool askLogout) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("askLogout", askLogout);
  }

  /// Stores the user preference of automatically logging in and their
  /// username/password if they do want to auto log in.
  void _setCredsSetting(bool saveCreds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (saveCreds) {
      //Save creds into persistent storage
      await prefs.setString('userName', globals.userName);
      await prefs.setString('userPass', globals.userPass);
      await prefs.setBool('autoLogIn', true);
    } else {
      //Remove creds from persistent storage
      await prefs.setString('userName', "");
      await prefs.setString('userPass', "");
      await prefs.setBool('autoLogIn', false);
    }
  }

  Widget _getAutoLogInWidget() {
    //Default to off for guest and disabled
    Widget retval = Row (
      children: [
        Text(
          'Automatically log in',
          textScaleFactor: 1.0,
        ),
        Switch(
          value: false,
          onChanged: null,
        ),
      ]
    );

    if ( globals.userName != globals.guestName ) {
      retval = Row (
        children: [
          Text(
            'Automatically log in',
            textScaleFactor: 1.0,
          ),
          Switch(
            value: lioSet.autoLogin,
            onChanged: (value) {
              setState(() {
                lioSet.autoLogin = value;
              });
              _setCredsSetting(value);
            },
            activeTrackColor: CustomColors.salmonAccent,
            activeColor: CustomColors.salmon,
          ),
          Text(
            'Ask to confirm log out',
            textScaleFactor: 1.0,
          ),
          Switch(
            value: lioSet.askLogout,
            onChanged: (value) {
              setState(() {
                lioSet.askLogout = value;
              });
              _setAskLogoutSetting(value);
            },
            activeTrackColor: CustomColors.salmonAccent,
            activeColor: CustomColors.salmon,
          ),
        ]
      );
    }

    return retval;
  }

  @override
  Widget build(BuildContext context) {
    if (globals.popupMsg != "") {
      Timer(Duration(milliseconds: 300), () {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: CustomColors.salmon,
            content: new Text(globals.popupMsg),
            duration: new Duration(seconds: 5),
          ),
        );
        globals.popupMsg = "";
      });
    }
    return new WillPopScope(
      onWillPop: () async {
        navPage = "/all_reports";
        Navigator.of(context).pushNamedAndRemoveUntil("/all_reports", ModalRoute.withName('/nada'));
        return false;
      },
      child: new Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
          backgroundColor: CustomColors.appBarColor,
        ),
        bottomNavigationBar: commonBottomBar(context),
        key: _scaffoldKey,
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
                        'Settings',
                        textAlign: TextAlign.center,
                        textScaleFactor: 2.0,
                      ),
                    ),
                  ),
                  Container(height: 30.0),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      child: Text(
                        'Select City:',
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ),
                  ColorSliverButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/settings_select_city');
                    },
                    child: Text(CityData().cities_resp.cities[globals.cityIdx].city_name),
                  ),
                  Container(height: 15.0),
                  _getAutoLogInWidget(),
                  Container(height: 15.0),
                  ColorSliverButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/feedback');
                    },
                    child: Text("Send Us Feedback")
                  )
                ]
              ),
            ),
            Container(
              width: 36.0,
            ),
          ]
        ),
      ),
    );
  }
}
  
  
