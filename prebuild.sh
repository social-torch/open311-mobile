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
$HERE/images/logo_512x512.jpg,512 \
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
# md5 or md5sum? Git Bash on Windows uses md5sum
MD5CMD="md5 -q"
if [ -z `command -v md5` ]; then 
    MD5CMD=md5sum # My Git bash on Windows uses md5sum, not md5
fi

# Determine if we've already generated the image by checking the template
# image's MD5 against a cached version. If the MD5 cache doesn't exist, or 
# it's different, generate the image
GEN_EM=true
GEN_MD5="$HERE/.gen-images-md5"
if [ -f $GEN_MD5 ]; then
    if [ "$($MD5CMD $TEMPLATE_IMG)" = "$(cat $GEN_MD5)" ]; then
        echo "Skipping image icon generation"
        GEN_EM=false
    fi
fi

# Determined we need to gen the image
if $GEN_EM; then
  # Save the template logo image hash
  echo $($MD5CMD $TEMPLATE_IMG) > $GEN_MD5
  if [ `command -v gm` ]; then
    # Ok, fine, try Graphicsmagick
    (
      for f in $GEN_IMAGES; do
        IMG=$(echo $f | cut -d',' -f1)
        SZ=$(echo $f | cut -d',' -f2)
        gm convert -resize ${SZ}x${SZ} $TEMPLATE_IMG $IMG
      done
    )
  else
    echo "Graphicsmagick not found or we need to update script"
  fi
fi
