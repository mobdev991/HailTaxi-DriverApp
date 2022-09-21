import 'package:firebase_database/firebase_database.dart';

class History {
  String? paymentMethod;
  String? createdAt;
  String? status;
  String? fares;
  String? dropOff;
  String? pickUp;
  String? referral_code;

  History(
      {this.paymentMethod,
      this.createdAt,
      this.status,
      this.fares,
      this.dropOff,
      this.pickUp,
      this.referral_code});

  History.fromSnapshot(DataSnapshot snapshot) {
    var data = snapshot.value as Map?;

    if (data != null) {
      paymentMethod = data["payment_method"];
      createdAt = data["created_at"];
      status = data["status"];
      fares = data["fares"];
      dropOff = data["dropoff_address"];
      pickUp = data["pickup_address"];
      referral_code = data["referral_code"];
    }
  }
}
