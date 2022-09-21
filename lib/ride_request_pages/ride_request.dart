import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hale_a_taxi/ride_request_pages/pickup_page.dart';

import '../config.dart';
import '../main.dart';

class RideRequestPage extends StatefulWidget {
  @override
  State<RideRequestPage> createState() => _RideRequestPageState();
}

class _RideRequestPageState extends State<RideRequestPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight / 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.5),
                    border: Border.all(color: Colors.grey.shade500, width: 3)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'NEW ORDER',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      wordSpacing: 4,
                      letterSpacing: 4),
                ),
              ),
              SizedBox(
                height: screenHeight / 15,
              ),
              Text(
                'Fixed Fare',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'AUD ${rideDetails!.fare}',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
              SizedBox(
                height: screenHeight / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${rideDetails!.ride_type}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '/',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${rideDetails!.ride_Subtype}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade900.withOpacity(0.8),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0, 7), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade200,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${rideDetails!.distance}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '${rideDetails!.duration}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              'PROMO',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: rideDetails!.referral_code == true
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              '${rideDetails!.pickup_short}',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Text('${rideDetails!.pickup_rest}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade200,
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              '${rideDetails!.dropoff_short}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Text('${rideDetails!.dropoff_rest}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 10,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 16, horizontal: 50)),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 20))),
                  onPressed: () {
                    print(
                        "onpressed for accepted is called.......................................................");
                    rideRequestIDGlobal = rideDetails!.ride_request_id;
                    checkAvailabilityOfRide(context);
                  },
                  child: Text('ACCEPT ORDER',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500))),
              SizedBox(
                height: screenHeight / 10,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red.shade300),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 16, horizontal: 50)),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 20))),
                  onPressed: () {
                    print("onpressed for cancel is called");
                    driverRef
                        .child(currentFirebaseUser!.uid)
                        .child('newRide')
                        .set('searching');
                    print('Driver Status Ride');
                    Navigator.of(context).pop();
                  },
                  child: Text('REJECT ORDER',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500))),
              SizedBox(
                height: screenHeight / 20,
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void setRideStatusToCancel() {
    DatabaseReference newRideRef =
        driverRef.child(currentFirebaseUser!.uid).child('newRide');
    print('Ride');
    print(newRideRef.key);
    newRideRef.set('canceled');
  }

  void setRideStatusToAccepted() {
    DatabaseReference newRideRef =
        driverRef.child(currentFirebaseUser!.uid).child('newRide');
    print('Driver Status Ride');
    print(newRideRef.key);
    newRideRef.set('accepted');

    // DatabaseReference rideStatus = rideRequestRef.child(rideDetails.ride_request_id!).child("status");
    // print('RideStatus');
    // print(rideStatus.key);
    // rideStatus.set('accepte');
  }

  void checkAvailabilityOfRide(context) {
    print('inside check availabilityof ride');
    newRequestRef
        .child(rideDetails!.ride_request_id!)
        .once()
        .then((DatabaseEvent event) {
      Navigator.pop(context);
      print('rideRequestRef ::');
      print(newRequestRef.key);

      DataSnapshot snap = event.snapshot;

      print(snap.value);

      String theRideId = "";

      if (snap.exists) {
        theRideId =
            newRequestRef.child(rideDetails!.ride_request_id!).key.toString();
        print(' Ride ID :: ');
        print(theRideId);
      } else {
        print('Ride ID doesnot exists');
        displayToastMessage("Ride do not exists", context);
      }
      print('rideDetails ride request id');
      print(rideDetails!.ride_request_id);

      if (theRideId == rideDetails!.ride_request_id) {
        // AssistantMethods.disableHometabLiveLocationUpdates();
        setRideStatusToAccepted();
        newRequestRef
            .child(rideDetails!.ride_request_id!)
            .child('status')
            .set('accepted');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PickUpPage()));
      } else if (theRideId == 'cancelled') {
        displayToastMessage('Ride Cancelled', context);
      } else if (theRideId == 'timeout') {
        displayToastMessage('Request Timeout', context);
      } else {
        displayToastMessage('Ride Do not Existsss', context);
      }
    });
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
