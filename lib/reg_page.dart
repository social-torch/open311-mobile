import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'page.dart';
import 'globals.dart' as globals;
import 'data.dart';
import 'custom_colors.dart';
import 'my_homepage.dart';
import 'custom_widgets.dart';
import 'ensure_visibile_when_focused.dart';

final userPool = new CognitoUserPool(
    globals.userPoolId, globals.clientPoolId );

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
  final passwordAgainController = TextEditingController();
  final givenNameController = TextEditingController();
  final familyNameController = TextEditingController();
  final emailController = TextEditingController();

  final registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FocusNode _focusNodeUser = new FocusNode();
  FocusNode _focusNodePass = new FocusNode();
  FocusNode _focusNodePassVerify = new FocusNode();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodeFirstName = new FocusNode();
  FocusNode _focusNodeLastName = new FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    usernameController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    familyNameController.dispose();
    givenNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void register() async {
    try {
      final userAttributes = [
        new AttributeArg(name: 'given_name', value: givenNameController.text),
        new AttributeArg(name: 'family_name', value: familyNameController.text),
        new AttributeArg(name: 'email', value: emailController.text),
      ];
      await userPool.signUp(usernameController.text, passwordController.text,
          userAttributes: userAttributes);
      //_scaffoldKey.currentState.showSnackBar(
      //  SnackBar(
      //    content: new Text('Check your email for a registration code.'),
      //    duration: new Duration(seconds: 5),
      //  ),
      //);
      Navigator.of(context).pushNamedAndRemoveUntil('/confirm', ModalRoute.withName('/login'));
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
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: registrationFormKey,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              children: <Widget> [
                Text(
                  'Create an Account',
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
                      'Create an account, passwords must be at least 8 characters long and contain a number, special character, lowercase and uppercase letters',
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
                  height: 10.0
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
                      return value == passwordAgainController.text ? null : "Passwords must match.";
                    },
                    focusNode: _focusNodePass,
                  ),
                ),
                Container(
                  height: 10.0
                ),
                new EnsureVisibleWhenFocused(
                  focusNode: _focusNodePassVerify,
                  child: new TextFormField(
                    controller: passwordAgainController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: 'Password (Repeat)',
                    ),
                    onSaved: (String value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: (String value) {
                      return value == passwordController.text ? null : "Passwords must match.";
                    },
                    focusNode: _focusNodePassVerify,
                  ),
                ),
                Container(
                  height: 10.0
                ),
                new EnsureVisibleWhenFocused(
                  focusNode: _focusNodeEmail,
                  child: new TextFormField (
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
                    focusNode: _focusNodeEmail,
                  ),
                ),
                Container(
                  height: 10.0
                ),
                //Number special character upper and lowercase letter, 8 characters minimum
                new EnsureVisibleWhenFocused(
                  focusNode: _focusNodeFirstName,
                  child: new TextFormField (
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
                    focusNode: _focusNodeFirstName,
                  ),
                ),
                Container(
                  height: 10.0
                ),
                new EnsureVisibleWhenFocused(
                  focusNode: _focusNodeLastName,
                  child: new TextFormField(
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
                    focusNode: _focusNodeLastName,
                  ),
                ),
                Container(
                  height: 30.0,
                ),
                ColorSliverButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (registrationFormKey.currentState.validate()) {
                      register();
                    }
                  },
                  child: Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
