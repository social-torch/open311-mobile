import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'location.dart';
import 'bottom_app_bar.dart';
import 'custom_colors.dart';
import 'custom_widgets.dart';
import "globals.dart" as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

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

  void nextPage() {
    //If we have made it to here, then it is time to select a location/address
    var page = LocationUiPage();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(page.title)),
          bottomNavigationBar: commonBottomBar(context),
          body: page,
        ),
      ),
    );
  }

  void _setCredsSetting(bool saveCreds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (saveCreds) {
      //Save creds into persistent storage
      final cryptor = new PlatformStringCryptor();
      final String u_encrypted = await cryptor.encrypt(globals.userName, globals.key);
      final String p_encrypted = await cryptor.encrypt(globals.userPass, globals.key);
      await prefs.setString('userName', u_encrypted);
      await prefs.setString('userPass', p_encrypted);
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


