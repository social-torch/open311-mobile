import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'location.dart';
import 'bottom_app_bar.dart';
import 'custom_colors.dart';
import 'custom_widgets.dart';
import "globals.dart" as globals;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends Page {
  SettingsPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const SettingsBody();
  }
}

class SettingsBody extends StatefulWidget {
  const SettingsBody();

  @override
  State<StatefulWidget> createState() => SettingsBodyState();
}
          
class SettingsBodyState extends State<SettingsBody> {
  SettingsBodyState();

  bool isSwitched = true;

  Future<bool> _getInitialAutoLogInState() async {
    bool retval = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool autoLogIn = prefs.getBool('autoLogIn');
    if (autoLogIn != null) {
      retval = autoLogIn;
    }
    return retval;
  }

  @override
  void initState() {
    super.initState();
    _getInitialAutoLogInState().then((value) {
      setState(() {
        isSwitched = value;
      });
    });
  }

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
            value: isSwitched, 
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });
              _setCredsSetting(value);
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
    return new Scaffold (
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
      ),
      bottomNavigationBar: commonBottomBar(context),
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


