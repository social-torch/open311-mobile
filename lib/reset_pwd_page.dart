import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'page.dart';
import 'data.dart';
import 'reset_pwd_verify_page.dart';
import 'globals.dart' as globals;
import 'bottom_app_bar.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'ensure_visible_when_focused.dart';

final userPool = new CognitoUserPool(
  globals.userPoolId, globals.clientPoolId);

class ResetPasswordPage extends Page {
  ResetPasswordPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const ResetPasswordPageBody();
  }
}

class ResetPasswordPageBody extends StatefulWidget {
  const ResetPasswordPageBody();

  @override
  State<StatefulWidget> createState() => ResetPasswordPageBodyState();
}

class ResetPasswordPageBodyState extends State<ResetPasswordPageBody> {
  ResetPasswordPageBodyState();

  final usernameController = TextEditingController();

  final registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FocusNode _focusNodeUser = new FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    usernameController.dispose();
    super.dispose();
  }

  void resetPassword() async {
      final cognitoUser = new CognitoUser(usernameController.text, userPool);
      try {
        await cognitoUser.forgotPassword();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmResetPasswordPage(cognitoUser)),
        );
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
      ),
      bottomNavigationBar: commonBottomBar(context),
      body: Row (
        children: [
          Container(
            width: 36.0,
          ),
          Expanded (
            child: ListView(
              children: [
                Form(
                  key: registrationFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text(
                        'Reset Password',
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
                                'Type in your username and click \"Reset\" to receive an automated email to reset your password',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                              )
                          )
                      ),
                      Container(height: 30.0),
                      new EnsureVisibleWhenFocused(
                        focusNode: _focusNodeUser,
                        child: new TextFormField(
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
                          focusNode: _focusNodeUser,
                        ),
                      ),
                      Container(
                        height: 15.0,
                      ),
                      ColorSliverButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (registrationFormKey.currentState.validate()) {
                            resetPassword();
                          }
                        },
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }
}
