import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'ensure_visible_when_focused.dart';
import 'us_states.dart';
import 'package:dio/dio.dart';
import "globals.dart" as globals;
import 'cities.dart';

class RequestNewCityPage extends Page {
  RequestNewCityPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const RequestNewCityBody();
  }
}

class RequestNewCityBody extends StatefulWidget {
  const RequestNewCityBody();

  @override
  State<StatefulWidget> createState() => RequestNewCityBodyState();
}
          
class RequestNewCityBodyState extends State<RequestNewCityBody> {
  RequestNewCityBodyState();

  final registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String state = "AL";

  final cityController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final commentController = TextEditingController();
  FocusNode _focusNodeCity = new FocusNode();
  FocusNode _focusNodeFirstname = new FocusNode();
  FocusNode _focusNodeLastname = new FocusNode();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodeComment = new FocusNode();

  void submitRequest() {
    String rac_city;
    String rac_state;
    String rac_first_name;
    String rac_last_name;
    String rac_email;
    String rac_feedback;

    setState(() {
      rac_city = cityController.text;
      rac_state = state;
      rac_first_name = firstnameController.text ?? "";
      rac_last_name = lastnameController.text ?? "";
      rac_email = emailController.text ?? "";
      rac_feedback = commentController.text ?? "";
    });

    CityData().rac_resp = RequestAddCity( rac_city, rac_state, rac_first_name, rac_last_name, rac_email, rac_feedback);

    Navigator.of(context).pushReplacementNamed("/submit_new_city");
  }

  @override
  void dispose() {
    cityController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    commentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
      ),
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
                        'Request New City',
                        textAlign: TextAlign.center,
                        textScaleFactor: 2.0,
                      ),
                      Container(height: 30.0),
                      SizedBox (
                        width: 2 * DeviceData().ButtonHeight,
                        child: Image.asset('images/logo.png'),
                      ),
                      Container(height: 15.0),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                        Icon(Icons.business), 
                        Text("   State: "), 
                        DropdownButton<String>(
                        value: state,
                        style: new TextStyle(
                          color: CustomColors.salmon,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            state = newValue;
                          });
                        },
                        items: us_states.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                          ]
                        ),
                      ),
                      new EnsureVisibleWhenFocused(
                        focusNode: _focusNodeCity,
                        child: new TextFormField(
                          controller: cityController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.business),
                            hintText: 'City',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return value.length < 2 || value.length > 100 ? "City must be between 2 and 100 characters" : null;
                          },
                          onFieldSubmitted: (value) {
                            _focusNodeCity.unfocus();
                            FocusScope.of(context).requestFocus(_focusNodeFirstname);
                          },
                          focusNode: _focusNodeCity,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      new EnsureVisibleWhenFocused(
                        focusNode: _focusNodeFirstname,
                        child: new TextFormField(
                          controller: firstnameController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'First Name',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return value.length > 100 ? "Name must be less than 100 characters" : null;
                          },
                          onFieldSubmitted: (value) {
                            _focusNodeFirstname.unfocus();
                            FocusScope.of(context).requestFocus(_focusNodeLastname);
                          },
                          focusNode: _focusNodeFirstname,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      new EnsureVisibleWhenFocused(
                        focusNode: _focusNodeLastname,
                        child: new TextFormField(
                          controller: lastnameController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'Last Name',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return value.length > 100 ? "Name must be less than 100 characters" : null;
                          },
                          onFieldSubmitted: (value) {
                            _focusNodeLastname.unfocus();
                            FocusScope.of(context).requestFocus(_focusNodeEmail);
                          },
                          focusNode: _focusNodeLastname,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      new EnsureVisibleWhenFocused(
                        focusNode: _focusNodeEmail,
                        child: new TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: 'Email',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return (value.length == 0 || (value.length > 5 && value.contains("@"))) ? null : "Invalid Email";
                          },
                          onFieldSubmitted: (value) {
                            _focusNodeEmail.unfocus();
                            FocusScope.of(context).requestFocus(_focusNodeComment);
                          },
                          focusNode: _focusNodeEmail,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      new EnsureVisibleWhenFocused(
                        focusNode: _focusNodeComment,
                        child: new TextFormField(
                          //maxLines: 3,
                          maxLength: 200,
                          controller: commentController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.comment),
                            hintText: 'How can we improve your city?',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return null;
                          },
                          focusNode: _focusNodeComment,
                        ),
                      ),
                      Row(
                        children: [
                          FlatButton(
                            color: CustomColors.appBarColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                            textColor: Colors.white,
                            onPressed: () {
                              if (registrationFormKey.currentState.validate()) {
                                submitRequest();
                              }
                            },
                            child: Text( "Submit request"),
                          ),
                        ]
                      ),
                    ]
                  ),
                ),
                Container(
                  width: 36.0,
                ),
              ]
            ),
          )
        )
      )
    );
  }
}
      
      
