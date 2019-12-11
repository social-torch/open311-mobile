import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'dart:io';
import 'dart:async';
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
import 'ensure_visible_when_focused.dart';
import 'package:encrypt/encrypt.dart';

CognitoUserSession _cog_user_session;
CognitoUser _cog_user;

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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FocusNode _focusNodeUser = new FocusNode();
  FocusNode _focusNodePass = new FocusNode();

  bool authenticating = false;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void startRefreshTokTimer() async {
    const duration = const Duration(seconds: 3600);
    if ( (globals.refresh_tok_timer != null) && (globals.refresh_tok_timer.isActive) ) {
      globals.refresh_tok_timer.cancel();
    }
    globals.refresh_tok_timer = new Timer.periodic(
      duration,
      (timer) {
        try {
          _cog_user.refreshSession(CognitoRefreshToken(globals.userRefreshToken)).then((cus) {
            _cog_user_session = cus;
            globals.userAccessToken = _cog_user_session.getAccessToken().getJwtToken();
            globals.userIdToken = _cog_user_session.getIdToken().getJwtToken();
            globals.userRefreshToken = _cog_user_session.getRefreshToken().getToken();
          });
        } catch (e) {
          print(e);
        }
      }
    );
  }

  void authenticate() async {
    _cog_user = new CognitoUser(emailController.text, userPool);
    final authDetails = new AuthenticationDetails(
        username: emailController.text, password:
    passwordController.text);
    try {
      _cog_user_session = await _cog_user.authenticateUser(authDetails);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: new Text('Authenticated!'),
          duration: new Duration(seconds: 5),
        ),
      );
      globals.userAccessToken = _cog_user_session.getAccessToken().getJwtToken();
      globals.userIdToken = _cog_user_session.getIdToken().getJwtToken();
      globals.userRefreshToken = _cog_user_session.getRefreshToken().getToken();
      globals.userName = globals.userName = emailController.text.replaceAll('@','AT').replaceAll('+','PLUS');
      globals.userPass = passwordController.text;

      //Save creds into persistent storage
      final iv = IV.fromLength(16);
      final encrypter = Encrypter(new AES(globals.key));
      final encryptedUid = encrypter.encrypt(globals.userName, iv: iv);
      final encryptedPwd = encrypter.encrypt(globals.userPass, iv: iv);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', encryptedUid.base16);
      await prefs.setString('userPass', encryptedPwd.base16);
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

      startRefreshTokTimer();

      //This is a bit of a hack but force bottom app bar to change color appropriately
      navPage = "/all_reports";
      Navigator.of(context).pushNamedAndRemoveUntil('/all_reports', ModalRoute.withName('/nada'));
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

    if (globals.popupMsg != "") {
      Timer(Duration(seconds: 1), () {
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
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: commonBottomBar(context),
        key: _scaffoldKey,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Form(
            child: new SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
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
                        new EnsureVisibleWhenFocused(
                          focusNode: _focusNodeUser,
                          child: new TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Email',
                            ),
                            onSaved: (String value) {
                              // This optional block of code can be used to run
                              // code when the user saves the form.
                            },
                            onFieldSubmitted: (value) {
                              _focusNodeUser.unfocus();
                              FocusScope.of(context).requestFocus(_focusNodePass);
                            },
                            focusNode: _focusNodeUser,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          height: 20.0,
                        ),
                        new EnsureVisibleWhenFocused(
                          focusNode: _focusNodePass,
                          child: new TextFormField(
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
                            focusNode: _focusNodePass,
                          ),
                        ),
                        Container(
                          height: 30.0,
                        ),
                        ColorSliverButton(
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if ( !authenticating && registrationFormKey.currentState.validate()) {
                              authenticating = true;
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
          ),
        ),
      ),
    );
  }
}
