# open311

The Open311 Project.

## Building

First define required environment variables, values below are bogus:

```bash
export OPEN311_COGNITO_USER_POOL="X"
export OPEN311_COGNITO_CLIENT_POOL="Y"
export OPEN311_GUEST_USERNAME="Z"
export OPEN311_GUEST_PASSWORD="A"
export OPEN311_ENCRYPT_KEY="B"
export OPEN311_BASE_URL="C"
export OPEN311_KEY_STORE_PW="D"
export OPEN311_KEY_STORE_FILE="E"
```

then build using our build script which wraps the standard `flutter` executable:

```bash
./flutter_it.sh run
```

Note: Without the KEY\_STORE env vars set, gradle may exit with a vague error:
```
* What went wrong:
A problem occurred evaluating project ':app'.
> path may not be null or empty string. path='null'
```
