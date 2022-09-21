import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hale_a_taxi/Verifications/vehicale_type.dart';

import '../config.dart';

class CarInfoForm extends StatefulWidget {
  const CarInfoForm({Key? key}) : super(key: key);

  @override
  _CarInfoFormState createState() => _CarInfoFormState();
}

class _CarInfoFormState extends State<CarInfoForm> {
  static const String screenId = "login";
  bool _isObscure = true;
  bool Trueee = true;
  bool errorSignUp = false;

  TextEditingController _regNoTextController = TextEditingController();
  TextEditingController _vehicalNameTextController = TextEditingController();
  TextEditingController _vehicalColorTextController = TextEditingController();
  int selectedType = 0;
  bool otherOptionsContainerVisibility = false;
  bool comfirmationButtonVisibility = false;
  String carType = 'Not-Selected';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildInputForm(
            'Vehical Model   e.g Mehran', false, _vehicalNameTextController),
        // buildInputForm('Last Name', false),
        buildInputForm(
            'Registration Number    e.g  LXR 999', false, _regNoTextController),
        buildInputForm(
            'Vehical Color  e.g  Black', false, _vehicalColorTextController),

        Text(
          errorSignUp == false ? "" : 'Invalid Formate : Too Short',
          style: TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Vehicle Type',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            RadioListTile<int>(
                value: 1,
                title: Text('Min Taxi'),
                subtitle: Text('3 seats'),
                groupValue: selectedType,
                onChanged: (value) {
                  print('value :: $value');
                  setState(() {
                    carType = 'Mini Taxi';
                    selectedType = 1;
                  });
                }),
            RadioListTile<int>(
                value: 2,
                title: Text('Taxi Sedan'),
                subtitle: Text('4 seats'),
                groupValue: selectedType,
                onChanged: (value) {
                  print('value :: $value');
                  setState(() {
                    selectedType = 2;
                    carType = 'Mini Sedan';
                    // otherOptionsContainerVisibility = true;
                    // comfirmationButtonVisibility = true;
                  });
                }),
            RadioListTile<int>(
                value: 3,
                title: Text('Maxi Taxi'),
                subtitle: Text('7 seats'),
                groupValue: selectedType,
                onChanged: (value) {
                  print('value :: $value');
                  setState(() {
                    selectedType = 3;
                    carType = 'Maxi Taxi';
                    // otherOptionsContainerVisibility = true;
                    // comfirmationButtonVisibility = true;
                  });
                }),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            onPressed: () {
              if (_regNoTextController.text.isEmpty) {
                displayToastMessage(
                    "Please Enter Vehical Registration Number", context);
              } else if (_vehicalNameTextController.text.isEmpty) {
                setState(() {
                  displayToastMessage("Enter Vehical Model Number", context);
                  errorSignUp = true;
                });
              } else if (_vehicalColorTextController.text.isEmpty) {
                displayToastMessage("Please Enter Vehical Number", context);
              } else if (carType == 'Not-Selected') {
                displayToastMessage("Please Enter Vehicle Type", context);
              } else {
                saveDriverCarInfo(context);
              }
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => VehicleType()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Extra Delivery',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.forward),
              ],
            ))
      ],
    );
  }

  Padding buildInputForm(
      String hint, bool pass, TextEditingController controller) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          controller: controller,
          obscureText: pass ? _isObscure : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.green.withOpacity(0.4)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
            suffixIcon: pass
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: _isObscure
                        ? Icon(
                            Icons.visibility_off,
                          )
                        : Icon(
                            Icons.visibility,
                          ))
                : null,
          ),
        ));
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  void saveDriverCarInfo(BuildContext context) {
    vehicleName = _vehicalNameTextController.text.trim();
    vehicleModel = _regNoTextController.text.trim();
    vehicleColor = _vehicalColorTextController.text.trim();
    vehicleType = carType;

    print("vehivale registered");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => VehicleType()),
        (route) => false);
  }
}
