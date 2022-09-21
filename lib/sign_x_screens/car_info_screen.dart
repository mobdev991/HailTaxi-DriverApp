import 'package:flutter/material.dart';

import 'car_info_form.dart';

class CarInfoScreen extends StatefulWidget {
  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  int selectedType = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight / 10,
            ),
            Column(
              children: [
                Text(
                  'Register Your Vehicle',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: CarInfoForm()),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
