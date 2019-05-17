import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'page.dart';
import 'globals.dart' as globals;
import 'ensure_visible_when_focused.dart';

final userPool = new CognitoUserPool(
  globals.userPoolId, globals.clientPoolId);

class ResendConfirmPage extends Page {
  ResendConfirmPage() : super(const Icon(Icons.map), 'Resend Registration Code');

  @override
  Widget build(BuildContext context) {
    return const ResendConfirmPageBody();
  }
}

class ResendConfirmPageBody extends StatefulWidget {
  const ResendConfirmPageBody();

  @override
  State<StatefulWidget> createState() => ResendConfirmPageBodyState();
}

class ResendConfirmPageBodyState extends State<ResendConfirmPageBody> {
  ResendConfirmPageBodyState();

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

  void resend() async {
    try {
      final cognitoUser = new CognitoUser(usernameController.text, userPool);
      await cognitoUser.resendConfirmationCode();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: new Text('Sent!'),
          duration: new Duration(seconds: 5),
        ),
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
      body: SingleChildScrollView (
        child: Form(
          key: registrationFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (registrationFormKey.currentState.validate()) {
                      resend();
                    }
                  },
                  child: Text('Resend'),
                ),
                ),
          ],
        ),
      ),
      ),
    );
  }
}
