import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'page.dart';
import 'home.dart';
import 'reset_pwd_page.dart';
import 'globals.dart' as globals;

final userPool = new CognitoUserPool(
  globals.userPoolId, globals.clientPoolId);

class AuthPage extends Page {
  AuthPage() : super(const Icon(Icons.map), 'Authenticate');

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
        print(session);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: new Text('Authenticated!'),
            duration: new Duration(seconds: 5),
          ),
        );
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
      appBar: AppBar(title: Text('Authenticate')),
      body: SingleChildScrollView (
        child: Center(
        child: Form(
          key: registrationFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (registrationFormKey.currentState.validate()) {
                      authenticate();
                    }
                  },
                  child: Text('Authenticate'),
                ),
                ),
              RichText(
                text: new TextSpan (
                  children: [
                    new TextSpan(
                      text: "Forgot Password?",
                      style: new TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings: RouteSettings(name: '/auth'),
                                builder: (context) => ResetPasswordPage()),
                          );
                        },
                    ),
                  ],
                )
              ),
              RichText(
                text: new TextSpan (
                  children: [
                    new TextSpan(
                      text: "Click at your own risk!",
                      style: new TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          var page = HomePage();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/home'),
                              builder: (context) => Scaffold(
                                appBar: AppBar(title: Text(page.title)),
                                body: page,
                              ),
                            ),
                          );
                        },
                    ),
                  ],
                )
              )
          ],
        ),
      ),
        ),
      ),
    );
  }
}
