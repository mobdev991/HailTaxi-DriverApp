import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hale_a_taxi/Models/referral_details.dart';

import 'Models/allUsers.dart';
import 'Models/drivers.dart';
import 'Models/rideDetails.dart';

String apiKey = 'AIzaSyCmWajWpkwewN2uRPUxU5Z21UZUzJ02fV4';

String? joinedDate;

//Firebase Variables
User? firebaseUser;

Users? userCurrentInfo;

User? currentFirebaseUser;

StreamSubscription<Position>? homeTabPageStreamSubscription;

StreamSubscription<Position>? rideStreamSubscription;

Position? currentPosition;

Drivers? driversInformation;
ReferralDetails? referralInformation;

RideDetails? rideDetails;

String? rideRequestIDGlobal = '123';

String statusRide = "";
String onlineOrOffline = 'Offline';

bool languageEnglish = true;

String vehicleName = 'ND';
String vehicleModel = 'ND';
String vehicleColor = 'ND';
String vehicleType = 'ND';
