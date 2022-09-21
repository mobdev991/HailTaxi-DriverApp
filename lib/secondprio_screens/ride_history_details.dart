import 'package:flutter/material.dart';
import 'package:hale_a_taxi/sign_x_screens/sign_in_Page.dart';


class RideHistoryDetails extends StatefulWidget {
  const RideHistoryDetails({Key? key}) : super(key: key);
  @override
  State<RideHistoryDetails> createState() => _RideHistoryDetailsState();
}

class _RideHistoryDetailsState extends State<RideHistoryDetails> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Trip Details'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                      size: 30,
                          color: Colors.green,),
                      SizedBox(width: 20,),
                      Text('Rides PickUp Location ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade600),),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    children: [
                      Icon(Icons.circle,size: 15,color: Colors.grey,),
                      Icon(Icons.circle,size: 15,color: Colors.grey,),
                    ],
                  ),),
                  SizedBox(height: 5,),

                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                        size: 30,
                        color: Colors.red,),
                      SizedBox(width: 20,),
                      Text('Rider DropOff Locations ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade600),),

                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 1,),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                      child: Text('CASH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade600),)),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey
                    )
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey
                      )
                  ),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                      child: Text('HireCab',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade600),)),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey
                      )
                  ),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                      child: Text('4.4 KM',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade600),)),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0, 7), // changes position of shadow
                ),
              ],
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RECEIPT',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
                      SizedBox(height: 5,),
                      Text('Fare',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade600),),
                      SizedBox(height: 5,),
                      Text('Commission Deduction',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade600),),
                      SizedBox(height: 5,),
                      Text('ToTal Fare',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade700),),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade600),),
                      SizedBox(height: 5,),
                      Text('7.00',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade600),),
                      SizedBox(height: 5,),
                      Text('2.00',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade600),),
                      SizedBox(height: 5,),
                      Text('MYR 5.00',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade700),),

                    ],
                  ),
                ),
              ],
            ),
          ),),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}