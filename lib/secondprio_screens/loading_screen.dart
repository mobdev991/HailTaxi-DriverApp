import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hale_a_taxi/Models/referral_details.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Assistance/assistanceMethods.dart';
import '../Models/drivers.dart';
import '../config.dart';
import '../main.dart';
import '../main_screens/default_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: SpinKitFadingCube(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }

  void waitBeforeMove() async {
    await getCurrentDriverInfo();

    print('yo1');
    await Future.delayed(const Duration(seconds: 5));
    print('yo2');
    if (driversInformation != null) {
      print(
          'driversinformations is not null...............................................................');
      await getReferralInfo();
      if (referralInformation != null) {
        print(
            'referral is not null...............................................................');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DefaultPage()),
            (route) => false);
      } else {
        print(
            'referral information is NUll nibba .................................................');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoadingScreen()),
            (route) => false);
      }
    } else {
      print(
          'driversinformations is NULL...............................................................');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoadingScreen()),
          (route) => false);
    }
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
    waitBeforeMove();
  }

  void checkPermission() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      print('location permission is denied..............................');
    } else {
      print('location permission is NOT denied..............................');
    }

    if (status.isRestricted) {
      print('location permission is Restricted..............................');
    } else {
      print(
          'location permission is NOT Restricted..............................');
    }

    if (status.isPermanentlyDenied) {
      print(
          'location permission is PermanentlyDenied..............................');
    } else {
      print(
          'location permission is NOT PermanentalyDenied..............................');
    }
    if (status.isGranted) {
      print('location permission is Granted..............................');
    } else {
      showRequestPermissionDialog();
    }
  }

  void showRequestPermissionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Location Permission',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
              content: Text(
                'This APP collects location Data to enable "Ride Request" and "Location Tracking" Features, even when the app is closed or not in use',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Deny',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoDialogAction(
                  child: Text('Allow',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo)),
                  onPressed: () {
                    Permission.location.request();
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  Future<void> getCurrentDriverInfo() async {
    print("getCurrentDriverInfo Executed -----------------------------------");

    currentFirebaseUser = await FirebaseAuth.instance.currentUser;

    driverRef
        .child(currentFirebaseUser!.uid)
        .once()
        .then((DatabaseEvent event) {
      print("datasnap value in makedriver online..........................");
      DataSnapshot snap = event.snapshot;
      print(snap.value);
      if (snap.exists) {
        print('driverInformation assigned!!.................................');
        driversInformation = Drivers.fromSnapshot(snap);
      } else {
        return;
      }
    });

    AssistantMethods.retriveHistoryInfo(context);
    print(driversInformation);
    print('exited get driver info');
  }

  Future<void> getReferralInfo() async {
    print('Driver Information ${driversInformation!.referral_code}');
    if (driversInformation != null) {
      referralCodeRef
          .child(driversInformation!.referral_code)
          .once()
          .then((DatabaseEvent event) {
        print("datasnap value in makedriver online..........................");
        DataSnapshot snap = event.snapshot;
        print(snap.value);
        if (snap.exists) {
          print(
              'driverInformation assigned!!.................................');
          referralInformation = ReferralDetails.fromSnapshot(snap);
        } else {
          return;
        }
      });
    } else {
      return;
    }
  }
}
