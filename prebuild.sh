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

cat > ${HERE}/lib/auto_gen.dart << EOF
import 'package:encrypt/encrypt.dart' as encrypt;
String userPoolId = '${OPEN311_COGNITO_USER_POOL}';
String clientPoolId = '${OPEN311_COGNITO_CLIENT_POOL}';
String guestName = '${OPEN311_GUEST_USERNAME}';
String guestPass = '${OPEN311_GUEST_PASSWORD}';
final key = encrypt.Key.fromUtf8('${OPEN311_ENCRYPT_KEY}');
String endpoint311base = '${OPEN311_BASE_URL}';
EOF
