import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  String? created_at;
  String? distance;
  String? duration;
  int? fare;
  String? pickup_address;
  String? dropoff_address;
  LatLng? pickUp;
  LatLng? dropOff;
  bool? referral_code;
  String? ride_request_id;
  String? payment_method;
  String? rider_name;
  String? rider_phone;
  String? ride_type;
  String? ride_Subtype;
  String? pickup_short;
  String? pickup_rest;
  String? dropoff_short;
  String? dropoff_rest;

  RideDetails(
      {this.created_at,
      this.distance,
      this.duration,
      this.fare,
      this.pickup_address,
      this.dropoff_address,
      this.pickUp,
      this.dropOff,
      this.referral_code,
      this.ride_request_id,
      this.payment_method,
      this.rider_name,
      this.rider_phone,
      this.ride_type,
      this.ride_Subtype,
      this.pickup_rest,
      this.pickup_short,
      this.dropoff_rest,
      this.dropoff_short});

  RideDetails.fromSnapshot(DataSnapshot dataSnapshot) {
    var data = dataSnapshot.value as Map;
    print('datasnapShot of Ride Details................');
    print(dataSnapshot.value);

    if (data != null) {
      created_at = data["created_at"];
      distance = data["distance_text"];
      duration = data["duration_text"];
      fare = data["fare"];
      pickup_address = data["pickup_address"];
      dropoff_address = data["dropoff_address"];
      pickUp = LatLng(double.parse(data["pickup"]["latitude"]),
          double.parse(data["pickup"]["longitude"]));
      dropOff = LatLng(double.parse(data["dropoff"]["latitude"]),
          double.parse(data["dropoff"]["longitude"]));
      referral_code = data["referral_code"];
      payment_method = data["payment_method"];
      rider_name = data["rider_name"];
      rider_phone = data["ride_phone"];
      ride_type = data["rideTpye"];
      ride_Subtype = data["rideSubTpye"];
      pickup_short = data["pickup_short"];
      pickup_rest = data["pickup_rest"];
      dropoff_short = data["dropoff_short"];
      dropoff_rest = data["dropoff_rest"];
    } else {
      print('DataSnapShot of Ride-Details is NULLLLLLLLLLLLLL');
      return;
    }
  }
}
