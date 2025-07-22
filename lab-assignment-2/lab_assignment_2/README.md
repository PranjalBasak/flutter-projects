# broadcast_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Caution
After you `pub get`, some issues might arise. Follow the instructions to fix your issues.

## Step-1
1. Go to this file:

`C:\Users\User\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_broadcasts-0.4.0\android\build.gradle`
2. Inside the android {} block, add this line:
```
namespace 'dev.flutter_broadcasts'
```
It should look like:

```
android {
    namespace 'dev.flutter_broadcasts'
    // ...other config
}
```

## Step-2
1. Open this file:
pgsql
Copy code
C:\Users\User\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_broadcasts-0.4.0\android\src\main\AndroidManifest.xml
2. Remove the package attribute from the <manifest> tag.
Change this:

xml
Copy code
```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="de.kevlatus.flutter_broadcasts">
```
To this:

xml
Copy code
```
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
```

## Step-3
```
┌─ Flutter Fix ─────────────────────────────────────────────────────────────────────────────────┐
│ The plugin flutter_broadcasts requires a higher Android SDK version.                          │
│ Fix this issue by adding the following to the file                                            │
│ E:\projects\flutter-projects\lab-assignment-2\broadcast_app\android\app\build.gradle:         │
│ android {                                                                                     │
│   defaultConfig {                                                                             │
│     minSdkVersion 24                                                                          │
│   }                                                                                           │
│ }                                                                                             │
│                                                                                               │
│ Following this change, your app will not be available to users running Android SDKs below 24. │
│ Consider searching for a version of this plugin that supports these lower versions of the     │
│ Android SDK instead.                                                                          │
│ For more information, see: https://flutter.dev/to/review-gradle-config         
```


## Step-4


Go to 
`C:\Users\User\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_broadcasts-0.4.0\android`
- Linux: `/home/calypse/.pub-cache/hosted/pub.dev/flutter_broadcasts-0.4.0`
<br>

and see `build.gradle`


Replace `android{}` block with

```

android {
    namespace 'dev.flutter_broadcasts' // keep if it doesn't break

    compileSdkVersion 31

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }
    defaultConfig {
        minSdkVersion 24
    }
}
```

# Step-5
To make sure my app runs in Android 13+
Go to the pub.dev -> flutterbroadcast

Go to src -> FlutterBroadcastPlugin.kt

Add Import
```
import androidx.core.content.ContextCompat
```


Replace the start function
```
fun start(context: Context) {
        //context.registerReceiver(this, intentFilter)
        val flags = ContextCompat.RECEIVER_EXPORTED
        ContextCompat.registerReceiver(context, this, intentFilter, flags)


        Log.d(TAG, "starting to listen for broadcasts: " + names.joinToString(";"))
    }
```