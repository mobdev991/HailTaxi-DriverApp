import 'package:flutter/material.dart';
import 'package:hale_a_taxi/main_screens/default_page.dart';
import 'package:hale_a_taxi/sign_x_screens/phone_number.dart';
import 'package:hale_a_taxi/sign_x_screens/signup.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green.shade500,
      body: Center(
        child: Column(
          children: <Widget>[
          SizedBox(height: 80,),
        Image(image: AssetImage('assets/logoIcon.png'),
            width: 100,
            height: 100
        ),
            SizedBox(height: 10,),
            const Text(
              'Taxi Hire Service',style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w500),
            ),
        SizedBox(height: 120,),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                ),
                  onPressed: (){

                  },
                  child: Row(
                    children: [
                      Icon(Icons.facebook,size: 30,color: Colors.blue),
                      SizedBox(width: 20,),
                      Text('Continue With Facebook',style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500)),

                    ],
                  )),
            ),



            Padding(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                  ),
                  onPressed: (){
                  },
                  child: Row(
                    children: [
                      Icon(Icons.report_gmailerrorred,size: 30,color: Colors.black),
                      SizedBox(width: 20,),
                      Text('Continue With Google',style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500)),

                    ],
                  )),
            ),
            SizedBox(height: 10,),
            Text('or',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w300)),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                  ),
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Phone_number()));
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.call,size: 30,color: Colors.black),
                        SizedBox(width: 20,),
                        Text('Continue With Mobile Number',style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500)),

                      ],
                    ),
                  )),
            ),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}