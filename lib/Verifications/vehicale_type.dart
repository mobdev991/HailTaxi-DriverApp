import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../main.dart';
import '../sign_x_screens/take_photo.dart';

class VehicleType extends StatefulWidget {
  const VehicleType({Key? key}) : super(key: key);

  @override
  State<VehicleType> createState() => _VehicleTypeState();
}

class _VehicleTypeState extends State<VehicleType> {
  int wheelerSelected = 0;
  bool parcelSelected = false;
  bool petsSelected = false;
  bool otherOptionsContainerVisibility = false;
  bool comfirmationButtonVisibility = false;
  bool wheelerBool = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight / 10,
              ),
              Text(
                'Extra Delivery Options',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: screenHeight / 40,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Do you have wheeler facility?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Radio<int>(
                            value: 1,
                            groupValue: wheelerSelected,
                            onChanged: (value) {
                              print(wheelerSelected);
                              setState(() {
                                otherOptionsContainerVisibility = true;
                                comfirmationButtonVisibility = true;
                                wheelerSelected = value!;
                              });
                            }),
                        SizedBox(
                          width: 40,
                        ),
                        Text(
                          'No',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Radio<int>(
                            value: 2,
                            groupValue: wheelerSelected,
                            onChanged: (value) {
                              print(wheelerSelected);
                              setState(() {
                                otherOptionsContainerVisibility = true;
                                comfirmationButtonVisibility = true;
                                wheelerSelected = value!;
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: otherOptionsContainerVisibility,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Select Extra Delivery Options',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CheckboxListTile(
                          value: parcelSelected,
                          title: Text('Parcel Delivery'),
                          subtitle: Text('delivery parcels'),
                          onChanged: (value) {
                            setState(() {
                              parcelSelected = value!;
                            });
                          }),
                      CheckboxListTile(
                          value: petsSelected,
                          title: Text('Pet Delivery'),
                          subtitle: Text('deliver pets'),
                          onChanged: (value) {
                            setState(() {
                              petsSelected = value!;
                            });
                          }),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: comfirmationButtonVisibility,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Please Note: you need to provide pictures of your orignal government issued driver license & vehicle registration to '
                    'start working, you can submit them any time in Account setting on profile page and in app drawer',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red.withOpacity(0.5),
                        fontSize: 14,
                        letterSpacing: 1),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Visibility(
                  visible: comfirmationButtonVisibility,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10)),
                        onPressed: () {
                          if (wheelerSelected == 2) {
                            wheelerBool = false;
                          } else {
                            wheelerBool = true;
                          }
                          print('pet Selectet = $petsSelected');
                          print('parcel Selectet = $parcelSelected');
                          print('wheeler or not = $wheelerBool');
                          saveExtraDeliveryOption(context);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => Takephoto()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Submit',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(Icons.forward),
                          ],
                        )),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void saveExtraDeliveryOption(BuildContext context) async {
    String userId = currentFirebaseUser!.uid;

    print(currentFirebaseUser);
    print("----------current user------------------------");
    Map carTypeInfoMap = {
      "car_color": vehicleColor,
      "car_model": vehicleName,
      "car_number": vehicleModel,
      "car_type": vehicleType,
      "wheeler": wheelerBool,
      "parcel": parcelSelected,
      "pet": petsSelected,
    };

    print("details input ------------------");
    print(carTypeInfoMap);

    driverRef
        .child(userId)
        .child("car_details")
        .set(carTypeInfoMap)
        .onError((error, stackTrace) {
      print("vehicle registration error  ${error}");
    }).then((value) {
      print("vehivale registered");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Takephoto()),
          (route) => false);
    });
  }
}
