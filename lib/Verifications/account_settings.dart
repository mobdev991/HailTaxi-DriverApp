import 'package:flutter/material.dart';
import 'package:hale_a_taxi/Verifications/dialog_box/extra_delivery_box.dart';
import 'package:hale_a_taxi/Verifications/dialog_box/vehicle_type_box.dart';
import 'package:hale_a_taxi/Verifications/driver_id.dart';
import 'package:hale_a_taxi/Verifications/vehicle_verification.dart';
import 'package:hale_a_taxi/config.dart';

import '../secondprio_screens/app_drawer.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    if (driversInformation!.pstatus == 'ACTIVE') {
      isActive = true;
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Account Settings'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black26)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.transparent)),
                              child: Column(
                                children: [
                                  Text(
                                    'Vehicle Type',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'MaxiTaxi',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) =>
                                      VehicleTypeBox());
                            },
                            child: Icon(
                              Icons.settings,
                              size: 40,
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black26)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.transparent)),
                              child: Column(
                                children: [
                                  Text(
                                    'Extra Delivery',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Null',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) =>
                                      ExtraDeliveryBox());
                            },
                            child: Icon(
                              Icons.settings,
                              size: 40,
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black26)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.transparent)),
                              child: Column(
                                children: [
                                  Text(
                                    'Personal Verification',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DriverID()));
                            },
                            child: isActive
                                ? Icon(
                                    Icons.check,
                                    size: 40,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black26)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.transparent)),
                              child: Column(
                                children: [
                                  Text(
                                    'Vehicle Verification',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VehicleVerification()));
                            },
                            child: isActive
                                ? Icon(
                                    Icons.check,
                                    size: 40,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
