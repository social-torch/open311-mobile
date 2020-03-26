library open311.globals;

import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:async';
import 'auto_gen.dart' as autogen;

String userPoolId = autogen.userPoolId;
String clientPoolId = autogen.clientPoolId;
String guestName = autogen.guestName;
String guestPass = autogen.guestPass;
String userName;
String userPass;
String userAccessToken = 'nada';
String userIdToken = 'nada';
String userRefreshToken = 'nada';
String usernameSignup = 'nada';
String userCognitoId = 'nada';
List<String> userGroups = [ 'nada' ];

//Global info for popup messages, if string has data then next page that loads should show it
String popupMsg = "";

final key = autogen.key;

String endpoint311base = autogen.endpoint311base;
String helpURL = autogen.helpURL; // URL to the help page for the given app
String termsURL = autogen.termsURL; // URL to legal terms and conditions
//TODO: variable(s) below needs to be modified when user selects default city and persist after app closes
String endpoint311 = 'nada';
int cityIdx = 0;

//Refresh token timer, when expired request new token using refresh token
Timer refresh_tok_timer;

//Guest users can only submit new requests every N seconds
int sequentialReqDelay = 600;

/// Returns if the current user is a guest or not.
/// Cleans up the string compares and if we ever need
/// a different method we can replace it here
bool isGuestUser() {
  return userName == guestName;
}