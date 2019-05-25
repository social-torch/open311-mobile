library open311.globals;

import 'package:camera/camera.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

List<CameraDescription> cameras;
String userPoolId = 'us-east-1_NeYs2Npv8';
String clientPoolId = '1f7foa96janp89b2ncdjjoaejn';
String guestName = 'guest';
String guestPass = 'BGT%4rfv';
String userName;
String userPass;
String userAccessToken = 'nada';
String userIdToken = 'nada';
String userRefreshToken = 'nada';

final key = encrypt.Key.fromUtf8('afahefa674qio62i2nfazf2hgqlc9g74');

String endpoint311base = 'https://api.socialtorch.org';
//TODO: variable(s) below needs to be modified when user selects default city and persist after app closes
String endpoint311 = 'nada';
int cityIdx = 0;
