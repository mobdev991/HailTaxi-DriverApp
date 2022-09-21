import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Assistance/requestAssistant.dart';
import '../Models/address.dart';
import '../Models/allUsers.dart';
import '../Models/direactionDetails.dart';
import '../Models/history.dart';
import '../config.dart';
import '../main.dart';
import '../providers/appData.dart';

class AssistantMethods {
  Future<String> searchCoordinateAddress(Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyCmWajWpkwewN2uRPUxU5Z21UZUzJ02fV4";

    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      // placeAddress = response["results"][0]["formatted_address"];

      st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];

      placeAddress = st1 + st2;

      Address userPickUpAddress = new Address(
          placeAddress, placeAddress, position.latitude, position.longitude);

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails> obtainDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    print("printing initial pos ${initialPosition}");
    print("printing initial pos ${finalPosition}");

    String directionUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=AIzaSyCmWajWpkwewN2uRPUxU5Z21UZUzJ02fV4';
    var res = await RequestAssistant.getRequest(directionUrl);

    print('res on assistanceMethod called');
    print(res);
    // if (res == "failed") {
    //   return "";
    // }
    DirectionDetails directionDetails = DirectionDetails(
        distanceValue: res["routes"][0]["legs"][0]["distance"]["value"],
        durationValue: res["routes"][0]["legs"][0]["duration"]["value"],
        distanceText: res["routes"][0]["legs"][0]["distance"]["text"],
        durationText: res["routes"][0]["legs"][0]["duration"]["text"],
        encodedPoints: res["routes"][0]["overview_polyline"]["points"]);

    print('printing direction details');
    print(directionDetails);
    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    double totalFareAmount = (directionDetails.distanceValue / 1000) * 50;
    return totalFareAmount.truncate();
  }

  static void getCurrentOnLineUserInfo(BuildContext context) async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser!.uid;

    DatabaseReference reference =
        await FirebaseDatabase.instance.ref().child("drivers").child(userId);

    reference.child('newRide').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists) {
        print(snapshot.value.toString());
        Provider.of<AppData>(context, listen: false)
            .updateRideStatus(snapshot.value.toString());
      } else {
        String elseValue = 'offline';
        Provider.of<AppData>(context, listen: false)
            .updateRideStatus(elseValue);
      }
    });

    DatabaseEvent event = await reference.once();

    DataSnapshot snap = event.snapshot;

    print(
        "--------------------------------------------------------------------------- /n \n "
        "getcurrentonlineUSerINfo");

    print(reference.parent);
    print(reference.path);

    print("00000000000000");

    print(reference.key);
    print(snap.value);

    if (snap.exists) {
      userCurrentInfo = Users.fromSnapshot(snap);
      print("user current info printing----------------");
      print(userCurrentInfo!.phone);
      print(userCurrentInfo);
    }
  }

  static void disableHometabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static void enableHomeTabLiveLocationUpdate() {
    homeTabPageStreamSubscription!.resume();
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
  }

  static void retriveHistoryInfo(BuildContext context) {
    driverRef
        .child(currentFirebaseUser!.uid)
        .child('history')
        .once()
        .then((DatabaseEvent event) {
      print(
          "in-number-of-tripes...... retriveTravelHistoryInfo Functions-------------------");
      DataSnapshot snap = event.snapshot;
      print(snap.value);
      if (snap.exists) {
        // update total number of trips counts to provide

        Map<dynamic, dynamic> keys = snap.value as Map;
        int tripCounter = keys.length;

        Provider.of<AppData>(context, listen: false)
            .updateNumberOfTrips(tripCounter);

        // update trip keys to provide

        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      } else {
        return;
      }
    });
  }

  static void obtainTripRequestsHistoryData(BuildContext context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for (String key in keys) {
      newRequestRef.child(key).once().then((DatabaseEvent event) {
        DataSnapshot snap = event.snapshot;
        if (snap.exists) {
          print(snap);
          var history = History.fromSnapshot(snap);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistoryData(history);
        } else {
          return;
        }
      });
    }
  }

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        '${DateFormat.MMMd().format(dateTime)},${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}';

    return formattedDate;
  }
}
