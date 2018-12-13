import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'page.dart';

final userPool = new CognitoUserPool(
  'us-east-1_14d72f5a-86a7-48f7-85ad-589226b2f631', '71bcfdg2bvel54sn0r6bloaf7f');

class RegistrationPage extends Page {
  RegistrationPage() : super(const Icon(Icons.map), 'Registration');

  @override
  Widget build(BuildContext context) {
    return const RegistrationPageBody();
  }
}

class RegistrationPageBody extends StatefulWidget {
  const RegistrationPageBody();

  @override
  State<StatefulWidget> createState() => RegistrationPageBodyState();
}

class RegistrationPageBodyState extends State<RegistrationPageBody> {
  RegistrationPageBodyState();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final givenNameController = TextEditingController();
  final familyNameController = TextEditingController();
  final emailController = TextEditingController();

  final registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    usernameController.dispose();
    passwordController.dispose();
    familyNameController.dispose();
    givenNameController.dispose();
    super.dispose();
  }

  void register() async {
    var data;
    try {
      final userAttributes = [
        new AttributeArg(name: 'given_name', value: givenNameController.text),
        new AttributeArg(name: 'family_name', value: familyNameController.text),
        new AttributeArg(name: 'email', value: emailController.text),
      ];
      data = await userPool.signUp(usernameController.text, passwordController.text,
          userAttributes: userAttributes);
      print(data);
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: new Text('Error: ${e.message}'),
          duration: new Duration(seconds: 10),
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.people),
                  hintText: 'E-mail',
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String value) {
                  return value.length > 5 && value.contains("@") ? null: "Invalid email";
                },
              ),
              TextFormField(
                controller: givenNameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.people),
                  hintText: 'First Name',
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String value) {
                  return value.length < 1 ? "First name must not be empty" : null;
                },
              ),
              TextFormField(
                controller: familyNameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.people),
                  hintText: 'Last Name',
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String value) {
                  return value.length < 1 ? "Last name must not be empty" : null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (registrationFormKey.currentState.validate()) {
                      register();
                    }
                  },
                  child: Text('Submit'),
                ),
                ),
          ],
        ),
      ),
      ),
    );
  }
}
