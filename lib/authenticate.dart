import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "globals.dart" as globals;
import 'package:encrypt/encrypt.dart' as encrypt;

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
        globals.userName = encrypter.decrypt16(encryptedUid, iv: iv);
        globals.userPass = encrypter.decrypt16(encryptedPass, iv: iv);
      }
    }
    
    final userPool = new CognitoUserPool(globals.userPoolId, globals.clientPoolId);
    final cognitoUser = new CognitoUser(globals.userName, userPool);
    final authDetails = new AuthenticationDetails(
      username: globals.userName,
      password: globals.userPass);
    CognitoUserSession session = await cognitoUser.authenticateUser(authDetails);
    globals.userAccessToken = session.getAccessToken().getJwtToken();
    globals.userIdToken = session.getIdToken().getJwtToken();
    globals.userRefreshToken = session.getRefreshToken().getToken();
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
    globals.userName = globals.guestName;
    globals.userPass = globals.guestPass;
    await authenticate();
  }
}
