import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:hale_a_taxi/sign_x_screens/varification_otp.dart';

class Phone_number extends StatefulWidget {
  const Phone_number({Key? key}) : super(key: key);

  @override
  State<Phone_number> createState() => _Phone_numberState();
}

class _Phone_numberState extends State<Phone_number> {
  TextEditingController phoneController = TextEditingController();
  CountryCode countryCode = CountryCode.fromDialCode('+61');
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight / 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Enter Your Phone Number",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: screenHeight / 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: CountryCodePicker(
                      textOverflow: TextOverflow.visible,
                      padding: EdgeInsets.only(
                        top: 2,
                        bottom: 2,
                      ),
                      onChanged: (code) {
                        countryCode = code;
                      },
                      initialSelection: countryCode.dialCode,
                      showCountryOnly: true,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                  ),
                  Container(
                    width: screenWidth / 1.6,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                    child: TextField(
                      cursorColor: Colors.green,
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      //controller: phoneController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0),
                        ),
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.green),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0),
                        ),
                        hintText: 'Phone Number',
                        // border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(400, 50),
                      maximumSize: const Size(400, 50),
                      primary: Colors.green),
                  onPressed: () {
                    if (phoneController.text.isEmpty) {
                      print('emaptu');
                    } else {
                      print(countryCode);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Otp('$countryCode${phoneController.text}')),
                      );
                    }
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            SizedBox(
              height: screenHeight / 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Text(
                  'By proceeding, you agree to get calls, SMS messages and '
                  'Whatsapp messages from Taxi Hail Service and our affiliates.',
                  style:
                      TextStyle(height: 1.5, letterSpacing: 1, wordSpacing: 7),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.35,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Text(
                  'This app is protected by reCAPTCHA and Google Privacy Policy and Terms of Service apply',
                  style: TextStyle(
                    height: 1.5,
                    letterSpacing: 0,
                    wordSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
