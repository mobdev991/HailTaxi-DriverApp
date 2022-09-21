import 'package:flutter/material.dart';
import 'package:hale_a_taxi/sign_x_screens/phone_number.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({Key? key}) : super(key: key);
  @override
  State<ChoosePage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.green.shade500,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Image(
                image: AssetImage('assets/logoIcon.png'),
                width: 100,
                height: 100),
            SizedBox(
              height: 100,
            ),
            const Text(
              'EARN. CONNECT.',
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            const Text('CONTRIBUTE TO SOCIETY.',
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: 100,
            ),
            const Text(
              'Partner with us to drive your own',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const Text(
              'livelihood and more.',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Phone_number()));
                    },
                    child: Text('SIGN IN',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500))),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 18, horizontal: 40)),
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 20))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Phone_number()));
                    },
                    child: Text('SIGN UP',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green.shade500,
                            fontWeight: FontWeight.w500))),
              ],
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
