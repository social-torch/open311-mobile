library open311.globals;

import 'package:camera/camera.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:async';
import 'auto_gen.dart' as autogen;

List<CameraDescription> cameras;
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

//Global info for popup messages, if string has data then next page that loads should show it
String popupMsg = "";

final key = autogen.key;

String endpoint311base = autogen.endpoint311base;
//TODO: variable(s) below needs to be modified when user selects default city and persist after app closes
String endpoint311 = 'nada';
int cityIdx = 0;

//Refresh token timer, when expired request new token using refresh token
Timer refresh_tok_timer;
