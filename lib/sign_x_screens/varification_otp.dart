import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hale_a_taxi/secondprio_screens/loading_screen.dart';
import 'package:hale_a_taxi/sign_x_screens/signup.dart';

import '../config.dart';

class Otp extends StatefulWidget {
  String phoneNumber;
  Otp(this.phoneNumber);

  @override
  _OtpState createState() => _OtpState(this.phoneNumber);
}

class _OtpState extends State<Otp> {
  bool signinError = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String statusCode = '';
  String errorText = ' ';

  TextEditingController otpController = TextEditingController();

  bool otpVisibility = false;
  bool isButtonActive = true;
  String verificationID = "";
  String jazz = "";
  String numberPhone;
  _OtpState(this.numberPhone);

  @override
  void initState() {
    loginWithPhone(numberPhone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Verification Page :: ${numberPhone}');
    print('Verification Page :: ${numberPhone.length}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Verification',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 200,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: TextField(
                          autofocus: true,
                          controller: otpController,
                          showCursor: false,
                          readOnly: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            counter: Offstage(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.green),
                                borderRadius: BorderRadius.circular(0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.green),
                                borderRadius: BorderRadius.circular(0)),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      errorText,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          print(otpController.text);
                          verifyOTP(otpController.text.trim());
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => signuppage()));
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            maximumSize: const Size(100, 50),
                            primary: Colors.green),
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            'Verify',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 18,
              ),
              GestureDetector(
                onTap: () {
                  loginWithPhone(numberPhone);
                },
                child: Text(
                  "Resend New Code",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginWithPhone(String phoneNumber) async {
    print('in loginWithPhone : phone number :: $phoneNumber');

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            setState(() {
              errorText = 'User exists';
            });
            currentFirebaseUser = value.user;
            print('user is not null');
            print(currentFirebaseUser);

            if (value.additionalUserInfo!.isNewUser) {
              setState(() {
                errorText = 'New User';
              });
              print('new user :: ${value.additionalUserInfo!.isNewUser}');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => signuppage()),
                  (route) => false);
            } else {
              setState(() {
                errorText = 'Old User';
              });
              print('this user is not new :: should go to home page');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingScreen()),
                  (route) => false);
            }
          } else {
            print('user is null.. no user created  or exists');
            setState(() {
              errorText = 'User do  not exist exists';
            });
          }

          Fluttertoast.showToast(
              msg: "You are logged in successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.indigo,
              textColor: Colors.white,
              fontSize: 16.0);
        }).onError((error, stackTrace) {
          setState(() {
            errorText = error.toString();
          });
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print('verification is faild :: below is the reason why it failed ::');
        print(e.message);
        setState(() {
          isButtonActive = true;
          statusCode = ' Verification Failed :: Please Try Later :: $e';
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;

        verificationID = verificationId;
        print('code sent --- verificationID :: $verificationId :: \n yo');
        setState(() {
          statusCode = ' Code Sent ';
          isButtonActive = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationID = verificationId;
        print('code retrival time out');
      },
    );
  }

  void verifyOTP(String verifyCode) async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: verificationID, smsCode: verifyCode))
        .then((value) async {
      if (value.user != null) {
        setState(() {
          errorText = 'User exists';
        });
        currentFirebaseUser = value.user;
        print('user is not null');
        print(currentFirebaseUser);

        if (value.additionalUserInfo!.isNewUser) {
          setState(() {
            errorText = 'New User';
          });
          print('new user :: ${value.additionalUserInfo!.isNewUser}');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => signuppage()),
              (route) => false);
        } else {
          setState(() {
            errorText = 'Old User';
          });
          print('this user is not new :: should go to home page');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoadingScreen()),
              (route) => false);
        }
      } else {
        print('user is null.. no user created  or exists');
        setState(() {
          errorText = 'User do  not exist exists';
        });
      }

      Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    }).onError((error, stackTrace) {
      setState(() {
        errorText = error.toString();
      });
    });
  }
}
