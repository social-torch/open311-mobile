import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "globals.dart" as globals;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:async';
import 'dart:io';

CognitoUserSession _cog_user_session;
CognitoUser _cog_user;
bool firstTime = true;

void startRefreshTokTimer() async {
  const duration = const Duration(seconds: 3600);
  if ( (globals.refresh_tok_timer != null) && (globals.refresh_tok_timer.isActive) ) {
    globals.refresh_tok_timer.cancel();
  }
  globals.refresh_tok_timer = new Timer.periodic(
    duration,
    (timer) {
      try {
        _cog_user.refreshSession(CognitoRefreshToken(globals.userRefreshToken)).then((cus) {
          _cog_user_session = cus;
          globals.userAccessToken = _cog_user_session.getAccessToken().getJwtToken();
          globals.userIdToken = _cog_user_session.getIdToken().getJwtToken();
          globals.userGroups = new List<String>.from(_cog_user_session.getIdToken().payload['cognito:groups'] ?? [ "nada" ]);
          globals.userRefreshToken = _cog_user_session.getRefreshToken().getToken();
        });
      } catch (e) {
        print(e);
      }
    }
  );
}

void authenticate() async {
  try {
    
    //First attempt to pull user/pass from persistent data, unless user is guest
    if (globals.userName == null)
    { 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final encryptedUid = prefs.getString('userName');
      final encryptedPass = prefs.getString('userPass');
      if ( (encryptedUid == null) || (encryptedUid == "") || (encryptedUid == globals.guestName) ) {
        globals.userName = globals.guestName;
        globals.userPass = globals.guestPass;
      } else {
        final iv = encrypt.IV.fromLength(16);
        final encrypter = encrypt.Encrypter(encrypt.AES(globals.key));
        // print("globals.userName"); print(globals.userName);
        globals.userName = encrypter.decrypt16(encryptedUid, iv: iv);
        globals.userPass = encrypter.decrypt16(encryptedPass, iv: iv);
      }
    }
    
    final userPool = new CognitoUserPool(globals.userPoolId, globals.clientPoolId);
    _cog_user = new CognitoUser(globals.userName, userPool);
    final authDetails = new AuthenticationDetails(
      username: globals.userName,
      password: globals.userPass);
    _cog_user_session = await _cog_user.authenticateUser(authDetails);
    globals.userAccessToken = _cog_user_session.getAccessToken().getJwtToken();
    globals.userIdToken = _cog_user_session.getIdToken().getJwtToken();
    globals.userGroups = new List<String>.from(_cog_user_session.getIdToken().payload['cognito:groups'] ?? [ "nada" ]);
    globals.userRefreshToken = _cog_user_session.getRefreshToken().getToken();
    globals.userCognitoId = _cog_user_session.getIdToken().payload['cognito:username'];
    assert(() {
      if (false) {
        //Using assert here for debug only prints
        print("userAccessToken:");
        print(globals.userAccessToken);
        print("userIdToken:");
        print(globals.userIdToken);
        print("userRefreshToken:");
        print(globals.userRefreshToken);
      }
      return true;
    }());
    startRefreshTokTimer();
  } on CognitoUserNewPasswordRequiredException catch (e) {
    // handle New Password challenge
    print(e);
  } on CognitoUserMfaRequiredException catch (e) {
    // handle SMS_MFA challenge
    print(e);
  } on CognitoUserSelectMfaTypeException catch (e) {
    // handle SELECT_MFA_TYPE challenge
    print(e);
  } on CognitoUserMfaSetupException catch (e) {
    // handle MFA_SETUP challenge
    print(e);
  } on CognitoUserTotpRequiredException catch (e) {
    // handle SOFTWARE_TOKEN_MFA challenge
    print(e);
  } on CognitoUserCustomChallengeException catch (e) {
    // handle CUSTOM_CHALLENGE challenge
    print(e);
  } on CognitoUserConfirmationNecessaryException catch (e) {
    // handle User Confirmation Necessary
    print(e); 
  } catch (e) {
    //If saved user/pass is for whatever reason invalid, login using guest
    print(e);
    // first time try guest, else delay a bit before trying again, don't spam on network error
    if(firstTime) {
      firstTime = false;
    } else {
      sleep(const Duration(seconds: 1));
    }
    globals.userName = globals.guestName;
    globals.userPass = globals.guestPass;
    await authenticate();
  }
}
