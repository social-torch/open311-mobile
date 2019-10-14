#!/bin/bash

HERE="$( cd "$( dirname "${BASE_SOURCE[0]}" )" && pwd)"

if [ -z "${OPEN311_COGNITO_USER_POOL}" ]; then
  echo "OPEN311_COGNITO_USER_POOL not set, exiting..."
  exit 1
fi

if [ -z "${OPEN311_COGNITO_CLIENT_POOL}" ]; then
  echo "OPEN311_COGNITO_CLIENT_POOL not set, exiting..."
  exit 2
fi


if [ -z "${OPEN311_GUEST_USERNAME}" ]; then
  echo "OPEN311_GUEST_USERNAME not set, exiting..."
  exit 3
fi

if [ -z "${OPEN311_GUEST_PASSWORD}" ]; then
  echo "OPEN311_GUEST_PASSWORD not set, exiting..."
  exit 4
fi

if [ -z "${OPEN311_ENCRYPT_KEY}" ]; then
  echo "OPEN311_ENCRYPT_KEY not set, exiting..."
  exit 5
fi

if [ -z "${OPEN311_BASE_URL}" ]; then
  echo "OPEN311_BASE_URL not set, exiting..."
  exit 6
fi

if [ -z "${OPEN311_KEY_STORE_PW}" ]; then
  echo "WARNING:  OPEN311_KEY_STORE_PW not set, using bogus value..."
  OPEN311_KEY_STORE_PW=bogus
fi

if [ -z "${OPEN311_KEY_STORE_FILE}" ]; then
  echo "WARNING:  OPEN311_KEY_STORE_FILE not set, using bogus value..."
  OPEN311_KEY_STORE_FILE=${HERE}/prebuild.sh
fi

cat > ${HERE}/lib/auto_gen.dart << EOF
import 'package:encrypt/encrypt.dart' as encrypt;
String userPoolId = '${OPEN311_COGNITO_USER_POOL}';
String clientPoolId = '${OPEN311_COGNITO_CLIENT_POOL}';
String guestName = '${OPEN311_GUEST_USERNAME}';
String guestPass = '${OPEN311_GUEST_PASSWORD}';
final key = encrypt.Key.fromUtf8('${OPEN311_ENCRYPT_KEY}');
String endpoint311base = '${OPEN311_BASE_URL}';
EOF

cat > ${HERE}/android/key.properties << EOF
storePassword=${OPEN311_KEY_STORE_PW}
keyPassword=${OPEN311_KEY_STORE_PW}
keyAlias=key
storeFile=${OPEN311_KEY_STORE_FILE}
EOF

#Generate Icons/Images
TEMPLATE_IMG="$HERE/images/logo_512x512.png"
GEN_IMAGES=" \
$HERE/android/app/src/main/res/mipmap-hdpi/launcher_icon.png,72 \
$HERE/android/app/src/main/res/mipmap-mdpi/launcher_icon.png,48 \
$HERE/android/app/src/main/res/mipmap-xhdpi/launcher_icon.png,96 \
$HERE/android/app/src/main/res/mipmap-xxhdpi/launcher_icon.png,144 \
$HERE/android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png,192 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png,1024 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png,20 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png,40 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png,60 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png,29 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png,58 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png,87 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png,40 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png,80 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png,120 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png,120 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png,180 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png,76 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png,152 \
$HERE/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png,167 \
"
if [ -d /Applications/GIMP-2.10.app/Contents/MacOS ]; then
  ln -sf ${HERE}/gimp/batch-resize.scm /Applications/GIMP-2.10.app/Contents/Resources/share/gimp/2.0/scripts/
  GEN_EM=true
  GEN_MD5="$HERE/.gen-images-md5"
  if [ -f $GEN_MD5 ]; then
    if [ "$(md5 -q $TEMPLATE_IMG)" = "$(cat $GEN_MD5)" ]; then
      GEN_EM=false
    fi
  fi
  echo $(md5 -q $TEMPLATE_IMG) > $GEN_MD5
  if $GEN_EM; then
    (
    cd /Applications/GIMP-2.10.app/Contents/MacOS
    for f in $GEN_IMAGES; do
      IMG=$(echo $f | cut -d',' -f1)
      SZ=$(echo $f | cut -d',' -f2)
      cp $TEMPLATE_IMG $IMG
      ./gimp -i -b "(batch-resize \"$IMG\" $SZ $SZ)" -b '(gimp-quit 0)'
    done
    )
  fi
else
  echo "GIMP not found, or linux machine and we need to update script"
fi

