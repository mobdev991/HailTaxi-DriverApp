import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hale_a_taxi/config.dart';
import 'package:hale_a_taxi/main.dart';
import 'package:hale_a_taxi/secondprio_screens/app_drawer.dart';
import 'package:hale_a_taxi/secondprio_screens/loading_screen.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  GlobalKey<ScaffoldState> _scaffoldKEY = GlobalKey<ScaffoldState>();
  int currentIndexBot = 0;
  final screens = [];
  bool isLoading = false;
  double totalCost = 0;
  double paymentContainerHeight = 0;
  TextEditingController _tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKEY,
        drawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.grey.shade800,
          title: Text('THL Wallet'),
          centerTitle: true,
          actions: [
            Icon(Icons.notifications),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight / 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.5), width: 3),
                      color: Colors.white54,
                    ),
                    child: Column(
                      children: [
                        Text('Available Tokens',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.grey.shade600)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${driversInformation!.token}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 60,
                              color: Colors.green.shade600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        paymentContainerHeight = 200;
                      });
                    },
                    child: Container(
                      width: screenWidth / 1.2,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.5), width: 3),
                        color: Colors.white54,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Get More Tokens',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.grey.shade600)),
                          SizedBox(
                            width: screenWidth / 20,
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 30,
                            color: Colors.black54,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                        'Driver need a token to accept ride request, every ride consumes one token, driver cannot go online if he has zero tokens',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        )),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                child: AnimatedContainer(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.grey.shade300,
                  height: paymentContainerHeight,
                  duration: Duration(seconds: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter Tokens',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black54,
                          )),
                      SizedBox(
                        height: screenHeight / 80,
                      ),
                      Container(
                        width: screenWidth / 1.6,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              double valuedouble = double.parse(value);
                              double newCost = valuedouble * 1;
                              totalCost = newCost;
                            });
                          },
                          cursorColor: Colors.green,
                          controller: _tokenController,
                          keyboardType: TextInputType.number,
                          //controller: phoneController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.green),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 2.0),
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 80,
                      ),
                      Text('Total payable amount',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black54,
                          )),
                      SizedBox(
                        height: screenHeight / 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text('AUD',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black54,
                                        letterSpacing: 1)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('${totalCost}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 60,
                                        color: Colors.green.withOpacity(0.7),
                                        letterSpacing: 1)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              setState(() => isLoading = true);
                              DatabaseReference ref = driverRef
                                  .child(driversInformation!.id)
                                  .child('tokens');
                              int tokensBefore =
                                  int.parse(driversInformation!.token);
                              int tokenNow = tokensBefore + totalCost.toInt();
                              ref.set(tokenNow.toString());
                              await Future.delayed(Duration(seconds: 5));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoadingScreen()),
                                  (route) => false);
                            },
                            child: Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2, color: Colors.black54)),
                              child: isLoading
                                  ? Container(
                                      padding: EdgeInsets.all(6),
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                    )
                                  : Image.asset(
                                      "assets/gpay.png",
                                      height: 80,
                                      width: 80,
                                    ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ],
        )

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
