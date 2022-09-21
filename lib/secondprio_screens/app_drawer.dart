import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hale_a_taxi/secondprio_screens/referral_screen.dart';
import 'package:hale_a_taxi/secondprio_screens/support_page.dart';
import 'package:hale_a_taxi/sign_x_screens/choose_screen.dart';

import '../config.dart';
import '../main_screens/history_page.dart';
import '../main_screens/wallet_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      child: Container(
        color: Colors.black87,
        child: ListView(
          children: [
            Container(
                color: Colors.grey.shade800,
                child: DrawerHeader(
                    child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border:
                                Border.all(color: Colors.white54, width: 4)),
                        child: CircleAvatar(
                          radius: screenWidth / 12,
                          backgroundColor: Colors.grey.shade800,
                          backgroundImage: NetworkImage(driversInformation!
                                      .pic !=
                                  null
                              ? driversInformation!.pic
                              : 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?cs=srgb&dl=pexels-pixabay-220453.jpg&fm=jpg&w=640&h=960'),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        driversInformation!.name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.white,
                        )),
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            driversInformation!.car_number,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  // color: Colors.indigo,
                ))),
            ListTile(
              leading: Icon(Icons.history, color: Colors.white),
              title: Text(
                'History',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.payment, color: Colors.white),
              title: Text(
                'Wallet',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WalletPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.support_agent, color: Colors.white),
              title: Text(
                'Support',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SupportScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.qr_code, color: Colors.white),
              title: Text(
                'Referral Code',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReferralScreen()));
              },
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ChoosePage()),
                    (route) => false);
              },
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
