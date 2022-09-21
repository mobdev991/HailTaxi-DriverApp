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

class DriverID extends StatefulWidget {
  const DriverID({Key? key}) : super(key: key);

  @override
  State<DriverID> createState() => _DriverIDState();
}

class _DriverIDState extends State<DriverID> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _licenseNumberController = TextEditingController();
  DatabaseReference? personalVerificationRef;
  UploadTask? task;
  File? imageFront;
  File? imageBack;
  String? frontImage;
  String? backImage;
  bool isLoading = false;
  String errorText = '';

  String txtButtonFront = 'Front Of Driver License';
  String txtButtonBack = 'Back Of Driver License';
  IconData iconButtonFront = Icons.add;
  IconData iconButtonBack = Icons.add;
  Color colorIconFront = Colors.blue;
  Color colorIconBack = Colors.blue;
  bool isLoadingFront = false;
  bool isLoadingBack = false;

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
              'Personal Verification',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.withOpacity(0.8),
                  fontSize: 24),
            ),
            SizedBox(
              height: screenHeight / 20,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Please enter your full name, it should be similar to your name on Driver License',
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
                controller: _nameController,
                keyboardType: TextInputType.number,
                //controller: phoneController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  labelText: 'ENTER FULL NAME',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  hintText: 'Full Name',
                  // border: InputBorder.none,
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
                controller: _licenseNumberController,
                keyboardType: TextInputType.number,
                //controller: phoneController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  labelText: 'LICENCE NUMBER',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  hintText: 'Full Name',
                  // border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 60,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Please upload pictures of your Government Issued Driver License, you are request to upload front and back picture of your Driver License',
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
              height: screenHeight / 50,
            ),
            // Front img
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
                    txtButtonFront,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                  ),
                  GestureDetector(
                      onTap: () {
                        print('front');
                        pickFrontImage();
                      },
                      child: isLoadingFront
                          ? Container(
                              padding: EdgeInsets.all(6),
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            )
                          : Icon(
                              iconButtonFront,
                              color: colorIconFront,
                            ))
                ],
              ),
            ),
            SizedBox(
              height: screenHeight / 50,
            ),
            //Back img
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
                    txtButtonBack,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black45),
                  ),
                  GestureDetector(
                      onTap: () {
                        print('back');
                        pickBackImage();
                      },
                      child: isLoadingBack
                          ? Container(
                              padding: EdgeInsets.all(6),
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            )
                          : Icon(
                              iconButtonBack,
                              color: colorIconBack,
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
                'Please Note: You picture should follow these instruction:',
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
              height: screenHeight / 100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    '- You image should be clear and all text is readable',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    '- Include all edges of your Driver License',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    '- Submit front & back picture on correct box',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight / 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                errorText,
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
              height: screenHeight / 70,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green.shade400),
              onPressed: () async {
                if (_licenseNumberController.text.isEmpty) {
                  setState(
                      () => errorText = 'Please enter correct license number');
                } else if (_nameController.text.isEmpty) {
                  setState(() => errorText = 'Please enter your name');
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
    personalVerificationRef = FirebaseDatabase.instance
        .ref()
        .child("Personal Verification Requests")
        .push();

    print("Ride Request Ref ------------------------------");
    print(personalVerificationRef!.key);
    String verificationRequestID = personalVerificationRef!.key!;

    Map userDetails = {
      "user_name": driversInformation!.name,
      "user_phone": driversInformation!.phone,
      "user_refID": driversInformation!.id,
    };

    Map rideInfoMap = {
      "verification_type": 'Personal Verification',
      "name_on_license": _nameController.text.trim(),
      "license_number": _licenseNumberController.text.trim(),
      "front_image_license": frontImage,
      "back_image_license": backImage,
      "user_details": userDetails
    };

    personalVerificationRef!.set(rideInfoMap);
    driverRef
        .child(driversInformation!.id)
        .child('personal_verification')
        .set(verificationRequestID);
  }

  Future pickFrontImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      isLoadingFront = true;
      if (txtButtonFront.length < 7) {
        print('text length is less 7');
        txtButtonFront = image.name;
      } else {
        print('text length is more than 7');
        txtButtonFront = image.name.substring(0, 7);
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
        isLoadingFront = false;
        colorIconFront = Colors.green;
        iconButtonFront = Icons.check;
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
      isLoadingBack = true;
      if (txtButtonBack.length < 7) {
        print('text length is less 7');
        txtButtonFront = image.name;
      } else {
        print('text length is more than 7');
        txtButtonBack = image.name.substring(0, 7);
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
        isLoadingBack = false;
        colorIconBack = Colors.green;
        iconButtonBack = Icons.check;
      });
    });
    backImage = urlDownload;

    print('Download-Link: $frontImage');

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
