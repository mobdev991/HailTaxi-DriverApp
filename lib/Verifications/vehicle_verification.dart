import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config.dart';
import '../main.dart';

class VehicleVerification extends StatefulWidget {
  const VehicleVerification({Key? key}) : super(key: key);

  @override
  State<VehicleVerification> createState() => _VehicleVerificationState();
}

class _VehicleVerificationState extends State<VehicleVerification> {
  TextEditingController _vNameController = TextEditingController();
  TextEditingController _vColorController = TextEditingController();
  TextEditingController _vModelController = TextEditingController();

  DatabaseReference? vehicleVerificationRef;

  UploadTask? task;
  File? imageFront;
  File? imageBack;
  File? imageReg;
  String? frontImage;
  String? backImage;
  String? regImage;
  bool isLoading = false;
  String errorText = '';

  String textImageVehicleFront = 'Front Of Vehicle';
  String textImageVehicleBack = 'Back Of Vehicle';
  String textRegVehicle = 'Vehicle Registration';
  IconData iconImageVehicleFront = Icons.add;
  IconData iconImageVehicleBack = Icons.add;
  IconData iconRegVehicle = Icons.add;
  Color colorImageVehicleFront = Colors.blue;
  Color colorImageVehicleBack = Colors.blue;
  Color colorRegVehicle = Colors.blue;
  bool isLoadingImageVehicleFront = false;
  bool isLoadingImageVehicleBack = false;
  bool isLoadingRegVehicle = false;

  @override
  void initState() {
    checkStoragePermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight / 15,
            ),
            Text(
              'Vehicle Verification',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.withOpacity(0.8),
                  fontSize: 24),
            ),
            SizedBox(
              height: screenHeight / 100,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Please Note! the information your enter should match the documents your are posting',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 14,
                  letterSpacing: 1,
                  wordSpacing: 2,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 40,
            ),
            Container(
              width: screenWidth / 1.6,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: TextField(
                cursorColor: Colors.green,
                controller: _vNameController,
                keyboardType: TextInputType.number,
                //controller: phoneController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  labelText: 'Vehicle Name',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  hintText: 'Vehicle Name',
                  // border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 60,
            ),
            Container(
              width: screenWidth / 1.6,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: TextField(
                cursorColor: Colors.green,
                controller: _vModelController,
                keyboardType: TextInputType.number,
                //controller: phoneController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  labelText: 'Vehicle Model Number',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  hintText: 'Model Number',
                  // border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 60,
            ),
            Container(
              width: screenWidth / 1.6,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: TextField(
                cursorColor: Colors.green,
                controller: _vColorController,
                keyboardType: TextInputType.number,
                //controller: phoneController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  labelText: 'Vehicle Color',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  hintText: 'Vehicle Color',
                  // border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 80,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Please upload pictures two pictures of your vehicle, first should be front of the vehicle and second should be the driver side of the vehicle',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 14,
                  letterSpacing: 1,
                  wordSpacing: 2,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 80,
            ),
            // front of vehicle
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: screenWidth / 1.6,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.green)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    textImageVehicleFront,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                  ),
                  GestureDetector(
                      onTap: () {
                        print('front');
                        pickFrontImage();
                      },
                      child: isLoadingImageVehicleFront
                          ? Container(
                              padding: EdgeInsets.all(6),
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            )
                          : Icon(
                              iconImageVehicleFront,
                              color: colorImageVehicleFront,
                            ))
                ],
              ),
            ),
            SizedBox(
              height: screenHeight / 50,
            ),
            // side of vehicle
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: screenWidth / 1.6,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.green)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    textImageVehicleBack,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                  ),
                  GestureDetector(
                      onTap: () {
                        print('front');
                        pickBackImage();
                      },
                      child: isLoadingImageVehicleBack
                          ? Container(
                              padding: EdgeInsets.all(6),
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            )
                          : Icon(
                              iconImageVehicleBack,
                              color: colorImageVehicleBack,
                            ))
                ],
              ),
            ),
            SizedBox(
              height: screenHeight / 50,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Please upload picture of your Government issued vehicle registration documents',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.red.withOpacity(0.7),
                  fontSize: 14,
                  letterSpacing: 1,
                  wordSpacing: 2,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: screenHeight / 50,
            ),
            //reg upload
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: screenWidth / 1.6,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.green)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    textRegVehicle,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                  ),
                  GestureDetector(
                      onTap: () {
                        print('front');
                        pickRegImage();
                      },
                      child: isLoadingRegVehicle
                          ? Container(
                              padding: EdgeInsets.all(6),
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            )
                          : Icon(
                              iconRegVehicle,
                              color: colorRegVehicle,
                            ))
                ],
              ),
            ),
            SizedBox(
              height: screenHeight / 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green.shade400),
              onPressed: () async {
                if (_vNameController.text.isEmpty) {
                  setState(() => errorText = 'Please enter vehicle name');
                } else if (_vModelController.text.isEmpty) {
                  setState(() => errorText = 'Please enter vehicle model');
                } else if (_vColorController.text.isEmpty) {
                  setState(() => errorText = 'Please enter vehicle color');
                } else {
                  saveVerificationRequest();
                  setState(() => isLoading = true);
                  await Future.delayed(Duration(seconds: 5));
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: screenWidth / 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    isLoading
                        ? Container(
                            padding: EdgeInsets.all(6),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  void saveVerificationRequest() {
    print("save ride request function chalo");
    vehicleVerificationRef = FirebaseDatabase.instance
        .ref()
        .child("Vehicle Verification Requests")
        .push();

    print("Ride Request Ref ------------------------------");
    print(vehicleVerificationRef!.key);
    String verificationRequestID = vehicleVerificationRef!.key!;

    Map userDetails = {
      "user_name": driversInformation!.name,
      "user_phone": driversInformation!.phone,
      "user_refID": driversInformation!.id,
    };

    Map rideInfoMap = {
      "verification_type": 'Vehicle Verification',
      "name_of_vehicle": _vNameController.text.trim(),
      "model_of_model": _vModelController.text.trim(),
      "model_of_color": _vColorController.text.trim(),
      "front_image_vehicle": frontImage,
      "side_image_vehicle": backImage,
      "vehicle_registration": regImage,
      "user_details": userDetails
    };

    vehicleVerificationRef!.set(rideInfoMap);
    driverRef
        .child(driversInformation!.id)
        .child('vehicle_verification')
        .set(verificationRequestID);
  }

  Future pickFrontImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      isLoadingImageVehicleFront = true;
      if (textImageVehicleFront.length < 7) {
        print('text length is less 7');
        textImageVehicleFront = image.name;
      } else {
        print('text length is more than 7');
        textImageVehicleFront = image.name.substring(0, 7);
      }
    });
    String destination = 'profilepictures/$imageTemporary';
    this.imageFront = imageTemporary;

    task = uploadFile(
      destination,
      this.imageFront!,
    );

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    task?.whenComplete(() {
      setState(() {
        print('task completed .............................');
        isLoadingImageVehicleFront = false;
        colorImageVehicleFront = Colors.green;
        iconImageVehicleFront = Icons.check;
      });
    });
    frontImage = urlDownload;
    print('Download-Link: $frontImage');

    // driverRef.child(currentFirebaseUser!.uid).child('pic').set(urlDownload);
  }

  Future pickBackImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      isLoadingImageVehicleBack = true;
      if (textImageVehicleBack.length < 7) {
        print('text length is less 7');
        textImageVehicleBack = image.name;
      } else {
        print('text length is more than 7');
        textImageVehicleBack = image.name.substring(0, 7);
      }
    });
    String destination = 'profilepictures/$imageTemporary';
    this.imageBack = imageTemporary;

    task = uploadFile(
      destination,
      this.imageBack!,
    );

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    task?.whenComplete(() {
      setState(() {
        print('task completed .............................');
        isLoadingImageVehicleBack = false;
        colorImageVehicleBack = Colors.green;
        iconImageVehicleBack = Icons.check;
      });
    });
    backImage = urlDownload;

    print('Download-Link: $backImage');

    // driverRef.child(currentFirebaseUser!.uid).child('pic').set(urlDownload);
  }

  Future pickRegImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      isLoadingRegVehicle = true;
      if (textRegVehicle.length < 7) {
        print('text length is less 7');
        textRegVehicle = image.name;
      } else {
        print('text length is more than 7');
        textRegVehicle = image.name.substring(0, 7);
      }
    });
    String destination = 'profilepictures/$imageTemporary';
    this.imageReg = imageTemporary;

    task = uploadFile(
      destination,
      this.imageReg!,
    );

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    task?.whenComplete(() {
      setState(() {
        print('task completed .............................');
        isLoadingRegVehicle = false;
        colorRegVehicle = Colors.green;
        iconRegVehicle = Icons.check;
      });
    });
    regImage = urlDownload;

    print('Download-Link: $regImage');

    // driverRef.child(currentFirebaseUser!.uid).child('pic').set(urlDownload);
  }

  static firebase_storage.UploadTask? uploadFile(
      String destination, File file) {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on firebase_storage.FirebaseException catch (e) {
      return null;
    }
  }

  void checkStoragePermission() async {
    var status = await Permission.storage.status;

    if (status.isDenied) {
      print('storage permission is denied..............................');
    } else {
      print('storage permission is NOT denied..............................');
    }

    if (status.isRestricted) {
      print('storage permission is Restricted..............................');
    } else {
      print(
          'storage permission is NOT Restricted..............................');
    }

    if (status.isPermanentlyDenied) {
      print(
          'storage permission is PermanentlyDenied..............................');
    } else {
      print(
          'storage permission is NOT PermanentalyDenied..............................');
    }
    if (status.isGranted) {
      print('storage permission is Granted..............................');
    } else {
      showRequestPermissionDialog();
    }
  }

  void showRequestPermissionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Storage Permission',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
              content: Text(
                'This APP Need Storage permission to access your Gallary and upload a profile photo and verification documents',
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
                    Permission.storage.request();
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}
