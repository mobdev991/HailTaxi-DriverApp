import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hale_a_taxi/Models/rideDetails.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../main.dart';
import '../providers/appData.dart';
import '../ride_request_pages/ride_request.dart';

class PushNotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String notificationMsg = "waiting for Notification";

  // StreamController<DatabaseEvent> controller = StreamController<DatabaseEvent>();

  Stream<DatabaseEvent>? rideStreamSubscription;

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initialize(context) async {
    print("initializing Notifications ...................................");

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      print(payload);
    });

    late final FirebaseMessaging _messaging;

    _messaging = FirebaseMessaging.instance;

    var settinx = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settinx.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted the Permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        showNotificationOnForeground(event);
        retrieveRideRequestInfo(getRideRequestId(event.data), context);
        notificationMsg =
            "${event.notification!.title} ${event.notification!.body} I am coming from terminated state";
      });
    }

    //onmessage is we app is opened
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        retrieveRideRequestInfo(getRideRequestId(value.data), context);
        notificationMsg =
            "${value.notification!.title} body ${value.notification!.body} I am coming from terminated state";
        print(notificationMsg);
      } else {
        print(
            "no notification value.....................................................");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      retrieveRideRequestInfo(getRideRequestId(event.data), context);
      notificationMsg =
          "${event.notification!.title} body ${event.notification!.body} I am coming from background";
      print(notificationMsg);
    });
  }

  //getInitialMessage is called

  Future<String?> getToken() async {
    print("getToken Executed -----------------------------------");
    String? token;

    // firebaseMessaging.getToken().then((value) {
    //   print('tooken try 2');
    //   print(value);
    // });

    await FirebaseMessaging.instance.getToken().then((value) {
      token = value;
    }).onError((error, stackTrace) {
      print("This not recived Token ::");
      print(error);
    });

    print("This is Token ::");
    print(token);

    driverRef.child(currentFirebaseUser!.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");

    return token;
  }

  Future<String?> getRideRequestID() async {
    print("getToken Executed -----------------------------------");
    String? rideRequestID;

    // firebaseMessaging.getToken().then((value) {
    //   print('tooken try 2');
    //   print(value);
    // });

    await FirebaseMessaging.instance.getToken().then((value) {
      rideRequestID = value;
    }).onError((error, stackTrace) {
      print("This not recived Token ::");
      print(error);
    });

    print("This is Token ::");
    print(rideRequestID);

    driverRef.child(currentFirebaseUser!.uid).child("token").set(rideRequestID);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");

    return rideRequestID;
  }

  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequestId = "";
    if (Platform.isAndroid) {
      rideRequestId = message['ride_request_id'];

      print("This is Ride Request ID Android::");
      print(rideRequestId);
    } else {
      rideRequestId = message['ride_request_id'];
    }

    return rideRequestId;
  }

  String getRideFareAmount(Map<String, dynamic> message) {
    String rideFareAmount = "";
    if (Platform.isAndroid) {
      rideFareAmount = message['ride_fare'];

      print("This is Ride Request ID Android::");
      print(rideFareAmount);
    } else {
      rideFareAmount = message['ride_fare'];
    }

    return rideFareAmount;
  }

  //show the dialog when app is already opened
  static void showNotificationOnForeground(RemoteMessage message) {
    print("show Notification On Foreground called ...................");
    print("message: ${message}");

    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "com.rio.driver_side_complete", "riorider",
            importance: Importance.max, priority: Priority.high));

    print(notificationDetails);
    print(message.notification!.title);

    Random random = new Random();

    _notificationsPlugin.show(random.nextInt(100), message.notification!.title,
        message.notification!.body, notificationDetails,
        payload: message.data['message']);
  }

  void retrieveRideRequestInfo(
      String rideRequestId, BuildContext context) async {
    print('inside retrieve Ride Request info// ');
    print('ride request id :: ');
    print(rideRequestId);
    FirebaseDatabase.instance
        .ref()
        .child("Ride Requests")
        .child(rideRequestId)
        .once()
        .then((DatabaseEvent event) async {
      DataSnapshot snap = event.snapshot;
      print(snap.value);

      if (snap.exists) {
        print('ride Details assigned!!.................................');
        rideDetails = await RideDetails.fromSnapshot(snap);
        rideDetails?.ride_request_id = rideRequestId;
        Provider.of<AppData>(context, listen: false)
            .updateRideDetailsProvider(rideDetails!);

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => RideRequestPage());
      } else {
        print("Ride Request Snapshot doesnt exists-------------------------");
      }
    });
  }

  void showNotificationDialog(BuildContext context) {
    print('show Notification Dialog RUnning');
    DatabaseReference nearByDriverRef =
        driverRef.child(currentFirebaseUser!.uid);
    print(nearByDriverRef.key);

    rideStreamSubscription = nearByDriverRef.onValue;
    rideStreamSubscription?.listen((DatabaseEvent event) async {
      var controller = StreamController<String>();
      controller.add(statusRide);
      controller.close();
      print(event.snapshot);
      var data = event.snapshot.value as Map;
      // print(data);
      if (event.snapshot.value == null) {
        print('snapshot has no value');
        return;
      } else {
        print('snap has a value');
      }
      if (data["newRide"] != null) {
        statusRide = data["newRide"]!.toString();
        print('data status is not null');
        print(statusRide);
      } else {
        print('data status is null');
      }

      if (statusRide == "accepted") {
        print(statusRide);
        print('status ride accepted');
      } else if (statusRide == "searching") {
        print('searching');
      } else if (statusRide == "offline") {
        print('offline');
      } else if (statusRide == "canceled") {
        driverRef
            .child(currentFirebaseUser!.uid)
            .child('newRide')
            .set('searching');
        print('offline');
      } else if (statusRide.contains('-')) {
        // newRideRequestNotification();
        retrieveRideRequestInfo(statusRide, context);
        return;
      } else {
        print('printing ride status in esle $statusRide');
      }
    });
  }
}
