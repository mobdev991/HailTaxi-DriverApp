import 'package:flutter/material.dart';
import 'package:hale_a_taxi/main_screens/history_page.dart';
import 'package:hale_a_taxi/main_screens/home_page.dart';
import 'package:hale_a_taxi/main_screens/profile_page.dart';
import 'package:hale_a_taxi/main_screens/wallet_page.dart';
import 'package:hale_a_taxi/secondprio_screens/app_drawer.dart';
import 'package:intl/intl.dart';

import '../config.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({Key? key}) : super(key: key);
  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  GlobalKey<ScaffoldState> _scaffoldKEY = GlobalKey<ScaffoldState>();
  int currentIndexBot = 0;
  final screens = [HomePage(), WalletPage(), HistoryPage(), ProfilePage()];

  @override
  void initState() {
    print('lets go screen default initstate....');
    setDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKEY,
      drawer: AppDrawer(),
      body: IndexedStack(
        index: currentIndexBot,
        children: screens,
      ),

      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade900,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedFontSize: 10,
          currentIndex: currentIndexBot,
          onTap: (index) {
            setState(() {
              currentIndexBot = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.grey.shade800),
            BottomNavigationBarItem(
                icon: Icon(Icons.payment),
                label: 'Wallet',
                backgroundColor: Colors.grey.shade800),
            BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
                backgroundColor: Colors.grey.shade800),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.grey.shade800),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void setDate() {
    print('in setDate function');
    List months = [
      "January",
      "Febuary",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    print('setting date ............................................yo');
    if (driversInformation != null) {
      DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(driversInformation!.created_on);
      String finaDate = '${months[tempDate.month]}  ${tempDate.year}';
      // driversInformation!.created_on = finaDate;
      joinedDate = finaDate;
    } else {
      return;
    }
    print('exited set date');
  }
}
