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
                child: const Text(
                  'Key',
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  FirebaseCrashlytics.instance.setCustomKey('foo', 'bar');
                }),
            FlatButton(
                child: const Text(
                  'Log',
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  FirebaseCrashlytics.instance.log('Simulated crash');
                }),
            FlatButton(
                child: const Text(
                  'Crash',
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  FirebaseCrashlytics.instance.crash();
                }),
            FlatButton(
                child: const Text(
                  'Throw Error',
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  throw StateError('Uncaught error thrown by app.');
                }),
            FlatButton(
                child: const Text(
                  'Async out of bounds',
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  Future<void>.delayed(const Duration(seconds: 2), () {
                    final List<int> list = <int>[];
                    print(list[100]);
                  });
                }),
            FlatButton(
              child: const Text(
                'Record Error',
                style: TextStyle(fontSize: 22),
              ),
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
