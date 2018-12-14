import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'page.dart';
import 'globals.dart' as globals;

final userPool = new CognitoUserPool(
  globals.userPoolId, globals.clientPoolId);

class ResetPasswordVerifyPage extends Page {
  ResetPasswordVerifyPage() : super(const Icon(Icons.map), 'Reset Password (Verify)');

  @override
  Widget build(BuildContext context) {
    return const ResetPasswordVerifyPageBody();
  }
}

class ResetPasswordVerifyPageBody extends StatefulWidget {
  const ResetPasswordVerifyPageBody();

  @override
  State<StatefulWidget> createState() => ResetPasswordVerifyPageBodyState();
}

class ResetPasswordVerifyPageBodyState extends State<ResetPasswordVerifyPageBody> {
  ResetPasswordVerifyPageBodyState();

  final usernameController = TextEditingController();

  final registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      body: SingleChildScrollView (
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (registrationFormKey.currentState.validate()) {
                      resetPassword();
                    }
                  },
                  child: Text('Reset'),
                ),
                ),
          ],
        ),
      ),
      ),
    );
  }
}
