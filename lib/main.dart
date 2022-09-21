import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hale_a_taxi/secondprio_screens/loading_screen.dart';
import 'package:hale_a_taxi/sign_x_screens/choose_screen.dart';
import 'package:provider/provider.dart';

import '../providers/appData.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize('resource://drawable/ic_launcher', [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'New Ride Request Recivied',
        importance: NotificationImportance.High,
        defaultColor: Colors.white10,
        channelDescription: 'channelDescription',
        vibrationPattern: highVibrationPattern,
        playSound: true,
        soundSource: 'resource://raw/alert')
  ]);
  await Firebase.initializeApp();

  currentFirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppData()),
    ],
    child: MyApp(),
  ));
  print("main executted");
}

DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
DatabaseReference referralCodeRef =
    FirebaseDatabase.instance.ref().child("Referral Code");
DatabaseReference newRequestRef =
    FirebaseDatabase.instance.ref().child("Ride Requests");

DatabaseReference rideRequestRef = FirebaseDatabase.instance
    .ref()
    .child("drivers")
    .child(currentFirebaseUser!.uid)
    .child("newRide");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: FirebaseAuth.instance.currentUser == null
            ? ChoosePage()
            : LoadingScreen(),
      ),
    );
  }
}
