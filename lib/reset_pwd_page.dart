import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'page.dart';
import 'reset_pwd_verify_page.dart';
import 'globals.dart' as globals;
import 'bottom_app_bar.dart';
import 'custom_colors.dart';

final userPool = new CognitoUserPool(
  globals.userPoolId, globals.clientPoolId);

class ResetPasswordPage extends Page {
  ResetPasswordPage() : super(const Icon(Icons.map), 'Reset Password');

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
        //title: Text(APP_NAME),
        title: Text('Reset Password'),
        backgroundColor: CustomColors.appBarColor,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: commonBottomBar(context),
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
      ),
    );
  }
}
