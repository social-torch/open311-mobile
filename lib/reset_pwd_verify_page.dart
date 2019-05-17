import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'page.dart';
import 'ensure_visible_when_focused.dart';

class ConfirmResetPasswordPage extends Page {
  final CognitoUser cognitoUser;
  ConfirmResetPasswordPage(CognitoUser cognitoUser) : cognitoUser = cognitoUser, super(const Icon(Icons.map), 'Reset Password (Verify)');

  @override
  Widget build(BuildContext context) {
    return ConfirmResetPasswordPageBody(this.cognitoUser);
  }
}

class ConfirmResetPasswordPageBody extends StatefulWidget {
  final CognitoUser cognitoUser;
  const ConfirmResetPasswordPageBody(CognitoUser cognitoUser) : cognitoUser = cognitoUser;

  @override
  State<StatefulWidget> createState() => ConfirmResetPasswordPageBodyState(this.cognitoUser);
}

class ConfirmResetPasswordPageBodyState extends State<ConfirmResetPasswordPageBody> {
  final CognitoUser cognitoUser;
  ConfirmResetPasswordPageBodyState(CognitoUser cognitoUser) : cognitoUser = cognitoUser;

  final confirmCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordVerifyController = TextEditingController();

  final registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FocusNode _focusNodeNewPass = new FocusNode();
  FocusNode _focusNodeNewPassVerify = new FocusNode();
  FocusNode _focusNodeConfCode = new FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    confirmCodeController.dispose();
    passwordController.dispose();
    passwordVerifyController.dispose();
    super.dispose();
  }

  void confirmResetPassword() async {
      bool passwordConfirmed = false;
      try {
        print("Updated password to: " + passwordController.text);
        passwordConfirmed = await this.cognitoUser.confirmPassword(confirmCodeController.text, passwordController.text);
        if (!passwordConfirmed) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Color.fromARGB(255, 255, 0, 0),
              content: new Text('Error: Password Reset Failed'),
              duration: new Duration(seconds: 5),
            ),
          );
        }
        Navigator.popUntil(context, ModalRoute.withName("/auth"));
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
        title: Text('Reset Password'),
      ),
      body: SingleChildScrollView (
        child: Form(
          key: registrationFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              new EnsureVisibleWhenFocused(
                focusNode: _focusNodeNewPass,
                child: new TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'New Password',
                  ),
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return value == passwordVerifyController.text ? null : "Passwords must match.";
                  },
                  focusNode: _focusNodeNewPass,
                ),
              ),
              new EnsureVisibleWhenFocused(
                focusNode: _focusNodeNewPassVerify,
                child: new TextFormField(
                  controller: passwordVerifyController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'New Password (Verify)',
                  ),
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return value == passwordController.text ? null : "Passwords must match.";
                  },
                  focusNode: _focusNodeNewPassVerify,
                ),
              ),
              new EnsureVisibleWhenFocused(
                focusNode: _focusNodeConfCode,
                child: new TextFormField(
                  controller: confirmCodeController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Confirmation Code',
                  ),
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return value.contains('@') ? 'Do not use the @ char.' : null;
                  },
                  focusNode: _focusNodeConfCode,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (registrationFormKey.currentState.validate()) {
                      confirmResetPassword();
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
