import 'package:firebase_database/firebase_database.dart';

class Drivers {
  String name = ' ';
  String phone = ' ';
  String id = ' ';
  String email = ' ';
  String car_model = ' ';
  String car_color = ' ';
  String car_number = ' ';

  String created_on = ' ';
  String driven = ' ';
  String rating = ' ';
  String token = ' ';
  String trips = ' ';
  String pic = ' ';
  String pstatus = ' ';
  String balance = ' ';
  String referral_code = ' ';
  String invitation_code = ' ';
  String car_type = ' ';
  bool wheeler = false;
  bool parcel_delivery = false;
  bool pet_delivery = false;

  Drivers({
    required this.id,
    required this.phone,
    required this.name,
    required this.email,
    required this.car_model,
    required this.car_color,
    required this.car_number,
    required this.created_on,
    required this.driven,
    required this.rating,
    required this.token,
    required this.trips,
    required this.pic,
    required this.pstatus,
    required this.balance,
    required this.referral_code,
    required this.invitation_code,
    required this.car_type,
    required this.wheeler,
    required this.parcel_delivery,
    required this.pet_delivery,
  });

  Drivers.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key!;

    var data = dataSnapshot.value as Map?;
    print(' datasnapshot of driverss ::');
    print(dataSnapshot.value);

    if (data != null) {
      phone = data["phone"];
      name = data["name"];
      email = data["email"];
      car_model = data["car_details"]["car_model"];
      car_color = data["car_details"]["car_color"];
      car_number = data["car_details"]["car_number"];
      car_type = data["car_details"]["car_type"];
      created_on = data["created on"];
      driven = data["driven"];
      rating = data["rating"];
      token = data["tokens"];
      trips = data["trips"];
      pic = data["pic"];
      pstatus = data["pstatus"];
      balance = data["balance"];
      referral_code = data["referralCode"];
      invitation_code = data["invitationCode"];
      wheeler = data["car_details"]["wheeler"];
      parcel_delivery = data["car_details"]["parcel"];
      pet_delivery = data["car_details"]["pet"];
    }
  }
}
