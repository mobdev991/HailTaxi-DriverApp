import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hale_a_taxi/secondprio_screens/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/appData.dart';
import '../secondprio_screens/history_item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  GlobalKey<ScaffoldState> _scaffoldKEY = GlobalKey<ScaffoldState>();
  int currentIndexBot = 0;
  final screens = [];
  bool noTrips = true;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AppData>(context, listen: false).numberOfTrips != 0) {
      noTrips = false;
    }
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKEY,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade800,
            title: Text('History'),
            centerTitle: true,
            actions: [
              Icon(Icons.notifications),
            ],
          ),
          drawer: AppDrawer(),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: Text(
                    '${Provider.of<AppData>(context, listen: false).numberOfTrips} JOBS COMPLETED',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.grey.shade600),
                  ),
                ),
                noTrips
                    ? Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'there is no completed ride to show!',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.grey.shade600),
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (BuildContext context, index) {
                          return HistoryItem(
                              history:
                                  Provider.of<AppData>(context, listen: false)
                                      .tripHistoryDataList[index]);
                        },
                        separatorBuilder: (BuildContext context, index) =>
                            SizedBox(
                          height: 3,
                        ),
                        itemCount: Provider.of<AppData>(context, listen: false)
                            .tripHistoryDataList
                            .length,
                        padding: EdgeInsets.all(5),
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                      ),
              ],
            ),
          )

          // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
