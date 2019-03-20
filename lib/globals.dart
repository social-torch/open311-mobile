library open311.globals;

import 'package:camera/camera.dart';

List<CameraDescription> cameras;
String userPoolId = 'us-east-1_NeYs2Npv8';
String clientPoolId = '1f7foa96janp89b2ncdjjoaejn';
String endpoint311base = 'https://roqlqvkke4.execute-api.us-east-1.amazonaws.com/Prod';
//TODO: variable(s) below needs to be modified when user selects default city and persist after app closes
//String endpoint311 = 'nada';
String endpoint311 = 'https://roqlqvkke4.execute-api.us-east-1.amazonaws.com/Prod/Schenectady';
int cityIdx = 0;
