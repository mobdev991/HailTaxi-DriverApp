import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../../main.dart';

class ExtraDeliveryBox extends StatefulWidget {
  const ExtraDeliveryBox({Key? key}) : super(key: key);

  @override
  State<ExtraDeliveryBox> createState() => _ExtraDeliveryBoxState();
}

class _ExtraDeliveryBoxState extends State<ExtraDeliveryBox> {
  bool parcelSelected = false;
  bool petsSelected = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    if (driversInformation!.parcel_delivery == true) {
      parcelSelected = true;
    }
    if (driversInformation!.pet_delivery == true) {
      petsSelected = true;
    }
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: screenHeight / 2.2,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight / 60,
              ),
              Text(
                'Extra Delivery Options',
                style: TextStyle(
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 20),
              ),
              SizedBox(
                height: screenHeight / 60,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Select Your Ride Type',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 16),
                  ),
                  CheckboxListTile(
                      value: parcelSelected,
                      title: Text('Parcel Delivery'),
                      subtitle: Text('4 seats'),
                      onChanged: (value) {
                        setState(() {
                          parcelSelected = value!;
                          driversInformation!.parcel_delivery = parcelSelected;
                        });
                      }),
                  CheckboxListTile(
                      value: petsSelected,
                      title: Text('Pet Delivery'),
                      subtitle: Text('4 seats'),
                      onChanged: (value) {
                        setState(() {
                          petsSelected = value!;
                          driversInformation!.pet_delivery = petsSelected;
                        });
                      }),
                ],
              ),
              Text(
                'Extra Delivery Option can be changed any time and are effective immediately',
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
                    changeExtraDelivery();
                    setState(() => isLoading = true);
                    await Future.delayed(Duration(seconds: 5));
                    Navigator.pop(context);
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

  void changeExtraDelivery() {
    driverRef
        .child(driversInformation!.id)
        .child('car_details')
        .child('parcel')
        .set(parcelSelected);
    driverRef
        .child(driversInformation!.id)
        .child('car_details')
        .child('pet')
        .set(petsSelected);
  }
}
