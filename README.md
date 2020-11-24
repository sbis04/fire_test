# Fire Test

A sample app to test [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics) on iOS.

> Check out the article regarding this, [Practical guide: Flutter + Firebase + Codemagic (for iOS)](https://blog.codemagic.io/practical-guide-flutter-firebase-codemagic/)

![](https://github.com/sbis04/fire_test/raw/master/screenshot/crashlytics.png)

## Plugins

* [firebase_core](https://pub.dev/packages/firebase_core)
* [firebase_crashlytics](https://pub.dev/packages/firebase_crashlytics)

```yaml
dependencies:
  firebase_core: ^0.5.2
  firebase_crashlytics: ^0.2.3
```

## Sample app code

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fire Test'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
                child: const Text('Key'),
                onPressed: () {
                  FirebaseCrashlytics.instance.setCustomKey('foo', 'bar');
                }),
            FlatButton(
                child: const Text('Log'),
                onPressed: () {
                  FirebaseCrashlytics.instance.log('Simulated crash');
                }),
            FlatButton(
                child: const Text('Crash'),
                onPressed: () {
                  FirebaseCrashlytics.instance.crash();
                }),
            FlatButton(
                child: const Text('Throw Error'),
                onPressed: () {
                  throw StateError('Uncaught error thrown by app.');
                }),
            FlatButton(
                child: const Text('Async out of bounds'),
                onPressed: () {
                  Future<void>.delayed(const Duration(seconds: 2), () {
                    final List<int> list = <int>[];
                    print(list[100]);
                  });
                }),
            FlatButton(
              child: const Text('Record Error'),
              onPressed: () {
                try {
                  throw 'error_example';
                } catch (error, stackTrace) {
                  FirebaseCrashlytics.instance.recordError(error, stackTrace);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

## Troubleshooting

When I ran the app for the first time and navigated to the Crashlytics dashboard, it showed me the following issue, and the crash didn’t get reported:

![](https://github.com/sbis04/fire_test/raw/master/screenshot/missing_dSYM.png)

In order to fix this, follow the steps below:

* Open the `ios/` folder in **Xcode**.

* Select your main build target.

* Open the target’s **Build Settings** tab, then click **All**.

* Search for **Debug Information Format**.
  
  ![](https://github.com/sbis04/fire_test/raw/master/screenshot/dSYM_format.png)

* Set Debug Information Format to `DWARF with dSYM Fil`e for all your build types.

* Rebuild your app.

Now, if you refresh your **Crashlytics dashboard** page, it won’t show that issue.

## License

Copyright (c) 2020 Souvik Biswas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

