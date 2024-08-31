# secure_password_generator

A Flutter app to generate secure passwords.

## Features

- Generate passwords with max length of 8 using Secure random generator
- Easy to integrate with existing android and ios apps. Provided as AAR package
  
## Integrate the AAR generated in build directory into the Android Project

The Android team can then integrate the AAR file into their project by following these steps:

- [ ] Copy the AAR file from build directory into the libs directory of the Android project.
    Add the AAR as a Dependency:

- [ ] Modify the build.gradle file of the app module to include the AAR file as a dependency:

```groovy
Consuming the Module
1. Open <host>/app/build.gradle
2. Ensure you have the repositories configured, otherwise add them:

        String storageUrl = System.env.FLUTTER_STORAGE_BASE_URL ?: "https://storage.googleapis.com"
repositories {
    maven {
        url '/Volumes/Workspace/dev/myspace/flutter/secure_password_generator/secure_password_generator/build/host/outputs/repo'
    }
    maven {
        url "$storageUrl/download.flutter.io"
    }
}

3. Make the host app depend on the Flutter module:

dependencies {
    debugImplementation 'com.example.secure_password_generator:flutter_debug:1.0'
    profileImplementation 'com.example.secure_password_generator:flutter_profile:1.0'
    releaseImplementation 'com.example.secure_password_generator:flutter_release:1.0'
}


4. Add the `profile` build type:

        android {
            buildTypes {
                profile {
                    initWith debug
                }
            }
        }

To learn more, visit https://flutter.dev/to/integrate-android-archive
```
- [ ] Sync the project in Android Studio to ensure the AAR file is correctly added.
- [ ] In the Android project, you need to handle the MethodChannel in the MainActivity (or the appropriate Activity or Fragment).

**Using MainActivity**
```java
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "secure_password_generator";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("generatePassword")) {
                        int length = call.argument("length");
                        boolean includeUppercase = call.argument("includeUppercase");
                        boolean includeLowercase = call.argument("includeLowercase");
                        boolean includeNumbers = call.argument("includeNumbers");
                        boolean includeSpecial = call.argument("includeSpecial");

                        String password = PasswordGenerator.generatePassword(
                                length, includeUppercase, includeLowercase, includeNumbers, includeSpecial);

                        if (password != null) {
                            result.success(password);
                        } else {
                            result.error("UNAVAILABLE", "Password generation failed", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }
}
```
**Trigger Password Generation on Button Click**
- [ ] Add a button to your Android UI, and in the onClick method, trigger the password generation using the Flutter module.

```java
Button generatePasswordButton = findViewById(R.id.generate_password_button);
generatePasswordButton.setOnClickListener(v -> {
    new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
            .invokeMethod("generatePassword", null, new MethodChannel.Result() {
                @Override
                public void success(Object result) {
                    // Handle the generated password here
                    String generatedPassword = (String) result;
                    // Display or use the generated password
                }

                @Override
                public void error(String errorCode, String errorMessage, Object errorDetails) {
                    // Handle the error
                }

                @Override
                public void notImplemented() {
                    // Handle the method not implemented
                }
            });
});

```
### Key Points:

- **Dart Side:** (_channel Usage): The MethodChannel is used to invoke native methods from Dart. In this case, the generatePassword method in Dart triggers a method call to the native Android code.


- **Android Side:** The MethodChannel on the Android side listens for method calls from Dart and responds accordingly. It uses the same channel name (secure_password_generator) to establish a communication bridge.**
**

### When is MethodChannel Used?
The **MethodChannel** is primarily used to facilitate communication between the Flutter and native layers (Android/iOS). In this scenario:
Dart calls the native method using MethodChannel.invokeMethod.
The native code responds by executing the appropriate logic and returning the result back to the Dart code.

In summary, the **MethodChannel** in Dart must be used to send a request to the native Android code, and the Android code must respond via this channel. This facilitates the generation of a secure password in response to a call from the Android project.