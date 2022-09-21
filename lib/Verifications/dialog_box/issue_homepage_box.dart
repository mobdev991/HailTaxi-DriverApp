import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IssueHomePage extends StatefulWidget {
  const IssueHomePage({Key? key}) : super(key: key);

  @override
  State<IssueHomePage> createState() => _IssueHomePageState();
}

class _IssueHomePageState extends State<IssueHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          height: screenHeight / 4,
          color: Colors.grey.shade800,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Warning',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  SizedBox(
                    width: screenWidth / 40,
                  ),
                  Icon(
                    Icons.warning,
                    color: Colors.yellow,
                  )
                ],
              ),
              SizedBox(
                height: screenHeight / 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white70,
                  ),
                  SizedBox(
                    width: screenWidth / 40,
                  ),
                  Text(
                    'Should have more than 2 Tokens',
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        wordSpacing: 1),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight / 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white70,
                  ),
                  SizedBox(
                    width: screenWidth / 40,
                  ),
                  Text(
                    'Account status should be "ACTIVE" ',
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        wordSpacing: 1),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight / 80,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'if you have both fulfilled both conditions and still having this issue, Please contact customer support',
                  style: TextStyle(
                      color: Colors.yellow.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      wordSpacing: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
