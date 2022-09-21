import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hale_a_taxi/config.dart';
import 'package:hale_a_taxi/main.dart';

class VehicleTypeBox extends StatefulWidget {
  const VehicleTypeBox({Key? key}) : super(key: key);

  @override
  State<VehicleTypeBox> createState() => _VehicleTypeBoxState();
}

class _VehicleTypeBoxState extends State<VehicleTypeBox> {
  int selectedType = 0;
  DatabaseReference? verificationRequestRef;

  String verificationType = "Change Vehicle Type";
  String changeTo = 'N/D';
  String errorText = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          height: screenHeight / 1.85,
          child: Column(
            children: [
              Text(
                'Change Vehicle Type',
                style: TextStyle(
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 20),
              ),
              SizedBox(
                height: screenHeight / 100,
              ),
              Text(
                errorText,
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 15),
              ),
              SizedBox(
                height: screenHeight / 100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Your Ride Type',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 16),
                  ),
                  RadioListTile<int>(
                      value: 1,
                      title: Text('Mini Taxi'),
                      subtitle: Text('2 seats'),
                      groupValue: selectedType,
                      onChanged: (value) {
                        print('value :: $value');
                        setState(() {
                          selectedType = 1;
                        });
                      }),
                  RadioListTile<int>(
                      value: 2,
                      title: Text('Taxi Sedan'),
                      subtitle: Text('3 seats'),
                      groupValue: selectedType,
                      onChanged: (value) {
                        print('value :: $value');
                        setState(() {
                          selectedType = 2;
                        });
                      }),
                  RadioListTile<int>(
                      value: 3,
                      title: Text('Maxi Taxi'),
                      subtitle: Text('5 seats'),
                      groupValue: selectedType,
                      onChanged: (value) {
                        print('value :: $value');
                        setState(() {
                          selectedType = 3;
                        });
                      }),
                ],
              ),
              Text(
                'Vehicle type is changed after admin approval',
                style: TextStyle(
                    color: Colors.red.shade200,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 12),
              ),
              SizedBox(
                height: screenHeight / 100,
              ),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: Colors.green.shade400),
                  onPressed: () async {
                    setSelectedString();
                    print(driversInformation!.id);
                    print(selectedType);
                    if (selectedType == 0) {
                      setState(() {
                        errorText = 'Please select a vehicle type!';
                      });
                    } else {
                      saveVerificationRequest();
                      setState(() => isLoading = true);
                      await Future.delayed(Duration(seconds: 5));
                      Navigator.pop(context);
                      print(changeTo);
                    }
                  },
                  child: isLoading
                      ? Container(
                          padding: EdgeInsets.all(6),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ))
            ],
          ),
        ),
      ),
    );
  }

  void setSelectedString() {
    if (selectedType == 1) {
      changeTo = 'Mini Taxi';
    } else if (selectedType == 2) {
      changeTo = 'Taxi Sedan';
    } else if (selectedType == 3) {
      changeTo = 'Maxi Taxi';
    } else {
      return;
    }
  }

  void saveVerificationRequest() {
    print("save ride request function chalo");
    verificationRequestRef =
        FirebaseDatabase.instance.ref().child("Verification Requests").push();

    print("Ride Request Ref ------------------------------");
    print(verificationRequestRef!.key);
    String verificationRequestID = verificationRequestRef!.key!;

    Map userDetails = {
      "user_name": driversInformation!.name,
      "user_phone": driversInformation!.phone,
      "user_refID": driversInformation!.id,
    };

    Map rideInfoMap = {
      "verification_type": verificationType,
      "change_to": changeTo,
      "user_details": userDetails
    };

    verificationRequestRef!.set(rideInfoMap);
    driverRef
        .child(driversInformation!.id)
        .child('verificationRequest')
        .set(verificationRequestID);
  }
}
