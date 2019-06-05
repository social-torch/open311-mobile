import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import 'custom_colors.dart';
import 'custom_widgets.dart';
import 'globals.dart' as globals;

final userPool = new CognitoUserPool(
  globals.userPoolId, globals.clientPoolId);

class ConfirmPage extends Page {
  ConfirmPage() : super(const Icon(Icons.map), 'Confirm Registration');

  @override
  Widget build(BuildContext context) {
    return const ConfirmPageBody();
  }
}

class ConfirmPageBody extends StatefulWidget {
  const ConfirmPageBody();

  @override
  State<StatefulWidget> createState() => ConfirmPageBodyState();
}

class ConfirmPageBodyState extends State<ConfirmPageBody> {
  ConfirmPageBodyState();

  final codeController = TextEditingController();

  final registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    codeController.dispose();
    super.dispose();
  }

  void confirm() async {
    try {
      final cognitoUser = new CognitoUser(globals.usernameSignup, userPool);
      await cognitoUser.confirmRegistration(codeController.text);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: new Text('Confirmed!'),
          duration: new Duration(seconds: 5),
        ),
      );
      globals.popupMsg = "Registration Complete, please log in";
      Navigator.of(context).pushReplacementNamed('/login');
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
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
      ),
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView (
        child: Form(
          key: registrationFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text(
                'Confirm',
                textAlign: TextAlign.center,
                textScaleFactor: 2.0,
              ),
              SizedBox(
                width: 2 * DeviceData().ButtonHeight,
                child: Image.asset("images/logo.png"),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  child: Text(
                    'Check your email for a registration code.',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.0,
                  )
                )
              ),
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'Registration Code',
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
                child: ColorSliverButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (registrationFormKey.currentState.validate()) {
                      confirm();
                    }
                  },
                  child: Text('Confirm'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
