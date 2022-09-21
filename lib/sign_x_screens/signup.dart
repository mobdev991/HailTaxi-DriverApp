import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../config.dart';
import '../main.dart';
import 'car_info_screen.dart';

class signuppage extends StatefulWidget {
  const signuppage({Key? key}) : super(key: key);

  @override
  State<signuppage> createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _invitationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Hale A Taxi Service",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "create your public profile",
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: _nameTextController,
                      // autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'name',
                        prefixIcon: Icon(Icons.person),
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                        filled: true,
                        fillColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          //  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: _emailController,
                      // autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                        filled: true,
                        fillColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          //  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter Invitation Code (Optional)",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          controller: _invitationCodeController,
                          // autocorrect: true,
                          decoration: InputDecoration(
                            hintText: '',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.qr_code),
                              onPressed: () async {
                                scanQRCode();
                              },
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 15),
                            filled: true,
                            fillColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              //  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50.0,
                        width: 300.0,
                        child: ElevatedButton(
                          onPressed: () {
                            registerNewUser(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => CarInfoScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            "Create Account",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  String generateReferralCode() {
    var date = DateTime.now();
    String referralCode =
        '${_emailController.text.length}${date.day}${currentFirebaseUser!.phoneNumber![4]}${date.year}${currentFirebaseUser!.phoneNumber![5]}${currentFirebaseUser!.phoneNumber![3]}';
    print(referralCode);
    return referralCode;
  }

  void updateInvitationCodeBenifits() {
    // find the invitation code and get details
    referralCodeRef
        .child(_invitationCodeController.text.trim())
        .child('userSignedUp')
        .once()
        .then((DatabaseEvent event) {
      DataSnapshot snap = event.snapshot;
      if (snap.exists) {
        print('referral code userSignedUp is NOT NULL..........');
        print('alreadySignedUPUsers == ${snap.value}');
        int numberOfAlreadySignedUpUsers = int.parse(snap.value.toString());
        int newTotaleUsers = numberOfAlreadySignedUpUsers + 1;
        print('new Total Users == $newTotaleUsers');
        referralCodeRef
            .child(_invitationCodeController.text.trim())
            .child('userSignedUp')
            .set(newTotaleUsers.toString());
      } else {
        print('referral code userSignedUp is NULL..........');
        return;
      }
    });
    // find how many user users already signed up
    // do a plus one
  }

  void registerNewUser(BuildContext context) async {
    print("enterend registernew user -----------------------------------");
    if (currentFirebaseUser != null) //user created
    {
      // save his info
      //
      driverRef.child(currentFirebaseUser!.uid);

      Map userDataMap = {
        "name": _nameTextController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": currentFirebaseUser?.phoneNumber,
        "created on": DateTime.now().toString(),
        "trips": '0',
        "driven": '0',
        "rating": '5',
        'tokens': '0',
        'balance': '0',
        'pic': 'null',
        'pstatus': 'NOT-VERIFIED',
        'invitationCode': _invitationCodeController.text.trim(),
        'referralCode': generateReferralCode()
      };

      Map referralCode = {
        'userID': currentFirebaseUser!.uid,
        'userSignedUp': '0',
        'totalTokensEarned:': '0'
      };

      referralCodeRef.child(generateReferralCode()).set(referralCode);
      updateInvitationCodeBenifits();
      driverRef.child(currentFirebaseUser!.uid).set(userDataMap).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CarInfoScreen()),
            (route) => false);
      });

      firebaseUser = currentFirebaseUser;

      print("accout------created------");
    } else {
      return;
    }
  }

  Future<void> scanQRCode() async {
    final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6466', 'cancel', false, ScanMode.QR);

    if (!mounted) return;

    setState(() {
      this._invitationCodeController.text = qrCode.toString();
    });
  }
}
