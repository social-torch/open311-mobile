import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import 'custom_widgets.dart';
import 'bottom_app_bar.dart';
import 'new_report.dart';
import 'reset_pwd_page.dart';
import 'globals.dart' as globals;
import 'custom_colors.dart';
import 'my_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';


final userPool = new CognitoUserPool(
    globals.userPoolId, globals.clientPoolId);

class AuthPage extends Page {
  AuthPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const AuthPageBody();
  }
}

class AuthPageBody extends StatefulWidget {
  const AuthPageBody();

  @override
  State<StatefulWidget> createState() => AuthPageBodyState();
}

class AuthPageBodyState extends State<AuthPageBody> {
  AuthPageBodyState();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void authenticate() async {
    final cognitoUser = new CognitoUser(usernameController.text, userPool);
    final authDetails = new AuthenticationDetails(
        username: usernameController.text, password:
    passwordController.text);
    CognitoUserSession session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: new Text('Authenticated!'),
          duration: new Duration(seconds: 5),
        ),
      );
      globals.userAccessToken = session.getAccessToken().getJwtToken();
      globals.userIdToken = session.getIdToken().getJwtToken();
      globals.userRefreshToken = session.getRefreshToken().getToken();
      globals.userName = usernameController.text;
      globals.userPass = passwordController.text;

      //Save creds into persistent storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', globals.userName);
      await prefs.setString('userPass', globals.userPass);
      bool autoLogIn = prefs.getBool('autoLogIn');
      //Default to auto log in unless user has specified otherwise previously
      if (autoLogIn == null) {
        await prefs.setBool('autoLogIn', true);
      }
  
      assert(() {
        if (false) {
          //Using assert here for debug only prints
          print("userAccessToken:");
          print(globals.userAccessToken);
          print("userIdToken:");
          print(globals.userIdToken);
          print("userRefreshToken:");
          print(globals.userRefreshToken);
        }
        return true;
      }());

      //This is a bit of a hack but force bottom app bar to change color appropriately
      navPage = "/all_reports";
      Navigator.of(context).pushReplacementNamed('/all_reports');
    } on CognitoUserNewPasswordRequiredException catch (e) {
      // handle New Password challenge
      print(e);
    } on CognitoUserMfaRequiredException catch (e) {
      // handle SMS_MFA challenge
      print(e);
    } on CognitoUserSelectMfaTypeException catch (e) {
      // handle SELECT_MFA_TYPE challenge
      print(e);
    } on CognitoUserMfaSetupException catch (e) {
      // handle MFA_SETUP challenge
      print(e);
    } on CognitoUserTotpRequiredException catch (e) {
      // handle SOFTWARE_TOKEN_MFA challenge
      print(e);
    } on CognitoUserCustomChallengeException catch (e) {
      // handle CUSTOM_CHALLENGE challenge
      print(e);
    } on CognitoUserConfirmationNecessaryException catch (e) {
      // handle User Confirmation Necessary
      print(e);
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
          content: new Text('Error: ${e.message}'),
          duration: new Duration(seconds: 5),
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: commonBottomBar(context),
      body: Row (
        children: [
          Container(
            width: 36.0,
          ),
          Expanded(
            child: ListView(
              children: [
                Form(
                  key: registrationFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Container(
                        width: 36.0,
                      ),
                      Text (
                        'Log In',
                        textAlign: TextAlign.center,
                        textScaleFactor: 2.0,
                      ),
                      Container(height: 30.0),
                      SizedBox (
                        width: 2 * DeviceData().ButtonHeight,
                        child: Image.asset('images/logo.png'),
                      ),
                      Container(height: 30.0),
                      SizedBox(
                          width: double.infinity,
                          child: Container(
                              child: Text(
                                'Log in below or click \"Sign Up\" to create an account',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                              )
                          )
                      ),
                      Container(height: 30.0),
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Username',
                        ),
                        onSaved: (String value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String value) {
                          return value.contains('@') ? 'Do not use the @ char.' : null;
                        },
                      ),
                      Container(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Password',
                        ),
                        onSaved: (String value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String value) {
                          return null;
                        },
                      ),
                      Container(
                        height: 30.0,
                      ),
                      ColorSliverButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (registrationFormKey.currentState.validate()) {
                            authenticate();
                          }
                        },
                        child: Text('Authenticate'),
                      ),
                      Container(
                        height: 20.0,
                      ),
                      RichText(
                        text: new TextSpan (
                          children: [
                            new TextSpan(
                              text: "Forgot Password?",
                              style: new TextStyle(color: Colors.blue),
                              recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamedAndRemoveUntil('/reset_password', ModalRoute.withName('/login'));
                              },
                            ),
                          ],
                        )
                      ),
                      Container(
                        height: 20.0,
                      ),
                      RichText(
                        text: new TextSpan (
                          children: [
                            new TextSpan(
                              text: "Sign Up",
                              style: new TextStyle(color: Colors.blue),
                              recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamedAndRemoveUntil('/registration', ModalRoute.withName('/login'));
                              },
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ],
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
