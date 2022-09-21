import 'package:flutter/material.dart';
import 'package:hale_a_taxi/config.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'app_drawer.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Personal Profile'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 2,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Your Referral Code',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 80,
                  ),
                  Text(
                    '${driversInformation!.referral_code}',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight / 50,
                  ),
                  Text(
                    'Here\'s how you\'re doing',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 50,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'User SignedUp',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                        Text(
                          '${referralInformation!.userSignedUp}',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                      ]),
                  SizedBox(
                    height: screenHeight / 30,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tokens Earned',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                        Text(
                          '${referralInformation!.totalTokensEarned}',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                      ]),
                  SizedBox(
                    height: screenHeight / 20,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Tokens Earned',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                        QrImage(
                            data: driversInformation!.referral_code,
                            padding: EdgeInsets.all(20),
                            foregroundColor: Colors.white,
                            size: 200),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
