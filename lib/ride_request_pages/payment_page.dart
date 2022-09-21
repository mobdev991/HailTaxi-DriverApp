import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hale_a_taxi/config.dart';
import 'package:hale_a_taxi/main.dart';
import 'package:hale_a_taxi/secondprio_screens/loading_screen.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade800,
          title: Text('Collect Fare'),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: [
              Container(
                color: Colors.grey.shade200,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${rideDetails!.rider_name}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.withOpacity(0.8)),
                    ),
                    Text(
                      'CASH',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.withOpacity(0.8)),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                width: double.infinity,
                color: Colors.grey.shade800,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fixed Fare',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                        Text(
                          '${rideDetails!.fare}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Toll',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Others',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800),
                    ),
                    Text(
                      'AUD ${rideDetails!.fare}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.withOpacity(0.8)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight / 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Please collect "Fare" by hand, This app do not provide any online payment options in app.',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                      wordSpacing: 8),
                ),
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade800),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          vertical: 16, horizontal: screenWidth / 4.3)),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 20))),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoadingScreen()),
                        (route) => false);
                  },
                  child: Text('Fare Received',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500))),
            ],
          ),
        ));
  }

  void subTokens() {
    DatabaseReference ref =
        driverRef.child(driversInformation!.id).child('tokens');
    int remainingTokens = int.parse(driversInformation!.token);
    remainingTokens = remainingTokens - 2;
    ref.set(remainingTokens.toString());
    print(remainingTokens);
  }

  @override
  void initState() {
    subTokens();
    super.initState();
  }

  void awardInvitationCode() {
    int numberOfTrips = int.parse(driversInformation!.token);
    // check number of trips
    // if more than 3 then ignore
    // if less than 3
    if (numberOfTrips >= 3) {
      return;
    } else {
      // find invitation code
      referralCodeRef
          .child(driversInformation!.invitation_code)
          .child('userID')
          .once()
          .then((DatabaseEvent event) {
        // find owner of that invitation code
        DataSnapshot snap = event.snapshot;
        if (snap.exists) {
          // check if user is driver or rider
          // reward the ower with +3 tokes
          String userID = snap.value.toString();

          driverRef
              .child(userID)
              .child('tokens')
              .once()
              .then((DatabaseEvent event) {
            DataSnapshot snap = event.snapshot;
            String oldTokens = snap.value.toString();
            if (snap.exists) {
              // driver
              int driverOldTokenNumber = int.parse(oldTokens);
              int newTokenNumber = driverOldTokenNumber + 3;
              driverRef
                  .child(userID)
                  .child('tokens')
                  .set(newTokenNumber.toString());
            } else {
              // user
              userRef
                  .child(userID)
                  .child('activity_points')
                  .once()
                  .then((DatabaseEvent event) {
                DataSnapshot snapi = event.snapshot;
                String oldPoints = snap.value.toString();
                if (snapi.exists) {
                  int userOldPoints = int.parse(oldPoints);
                  int newPoints = userOldPoints + 3;
                  userRef
                      .child(userID)
                      .child('activity_points')
                      .set(newPoints.toString());
                } else {
                  return;
                }
              });
            }
          });
        } else {}
        if (snap.exists) {
        } else {
          print('referral code userSignedUp is NULL..........');
          return;
        }
      });
    }
  }
}
