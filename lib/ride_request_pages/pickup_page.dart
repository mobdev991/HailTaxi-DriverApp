import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hale_a_taxi/ride_request_pages/dropoff_page.dart';
import 'package:hale_a_taxi/secondprio_screens/app_drawer.dart';

import '../Assistance/assistanceMethods.dart';
import '../Assistance/mapKitAssistant.dart';
import '../config.dart';
import '../main.dart';

class PickUpPage extends StatefulWidget {
  @override
  State<PickUpPage> createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> {
  GlobalKey<ScaffoldState> _scaffoldKEY = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController? newGoogleMapControler;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController? newRideGoogleMapControler;

  Color mainButtonColor = Colors.green;
  String mainButtonText = 'Arrived On Spot';
  String status = 'accepted';
  String? durationRide = "";
  String? distanceRide = "";
  String? fareRide = "";
  bool isRequestingDirection = false;

  Set<Marker> markerSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polyLineSet = Set<Polyline>();

  List<LatLng> polylinesCordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Position? myPosition;
  BitmapDescriptor? animatingMarkerIcon;

  void mapInitialized(GoogleMapController controller) {
    print('google map controller called');
    _controllerGoogleMap.complete(controller);
    newGoogleMapControler = controller;
  }

  @override
  void initState() {
    acceptRideRequest();
    super.initState();
  }

  void createIconMarker() {
    print('createIconMarker is running meri jaan you................');
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(1, 1));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/carOnMap.png")
          .then((value) {
        animatingMarkerIcon = value;
        print(
            "icon assigned ---------------------------------------------------");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print(
        'on page pickup rider................................................');
    print(rideDetails!.pickUp);
    print(rideDetails!.ride_request_id);

    createIconMarker();

    return DefaultTabController(
        length: 1,
        child: Scaffold(
          key: _scaffoldKEY,
          drawer: AppDrawer(),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: screenHeight / 14,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              width: screenWidth / 2,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PICK-UP',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightBlueAccent
                                            .withOpacity(0.8)),
                                  ),
                                  Text(
                                    '${rideDetails!.rider_name}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              width: screenWidth / 2,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DROP-OFF',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.withOpacity(0.3)),
                                  ),
                                  Text(
                                    '${rideDetails!.rider_name}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.3)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        color: Colors.grey.shade800,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pick-Up Location',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    '${rideDetails!.pickup_address}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                  width: screenWidth / 1.5,
                                ),
                                SizedBox(
                                  width: screenWidth / 40,
                                ),
                                Icon(
                                  Icons.location_on,
                                  size: 30,
                                  color: Colors.red,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '${rideDetails!.ride_Subtype}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.6)),
                                  ),
                                  Text(
                                    '${rideDetails!.fare}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.greenAccent
                                            .withOpacity(0.8)),
                                  ),
                                  Text(
                                    'CASH',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade200),
                                  ),
                                  Text('PROMO',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              rideDetails!.referral_code == true
                                                  ? Colors.green
                                                  : Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 500,
                        child: GoogleMap(
                            mapType: MapType.normal,
                            myLocationButtonEnabled: true,
                            initialCameraPosition: _kGooglePlex,
                            markers: markerSet,
                            circles: circleSet,
                            polylines: polyLineSet,
                            onMapCreated:
                                (GoogleMapController controller) async {
                              _controllerGoogleMap.complete(controller);
                              newRideGoogleMapControler = controller;
                              var currentLatLng = LatLng(
                                  currentPosition!.latitude,
                                  currentPosition!.longitude);
                              var pickUpLatLang = rideDetails!.pickUp;
                              await getPlaceDirection(
                                  currentLatLng, pickUpLatLang!);
                              getRideLocationUpdated();
                            }),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.grey.shade800,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 7), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                    ),
                                    border: Border.all(
                                        color: Colors.grey.shade900)),
                                width: screenWidth / 3,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.call,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('CALL',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade900)),
                                width: screenWidth / 3,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.chat,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('CHAT',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.grey.shade900)),
                                width: screenWidth / 3,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('AVAILABLE',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: screenWidth / 1.5,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  mainButtonColor),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  vertical: screenHeight / 50,
                                                  horizontal:
                                                      screenWidth / 10)),
                                          textStyle: MaterialStateProperty.all(
                                              TextStyle(fontSize: 20))),
                                      onPressed: () {
                                        if (mainButtonText ==
                                            'Arrived On Spot') {
                                          print('Arrived on Spot Clicked');
                                          String? rideRequestId =
                                              rideDetails!.ride_request_id;
                                          newRequestRef
                                              .child(rideRequestId!)
                                              .child("status")
                                              .set('arrived');

                                          setState(() {
                                            mainButtonText = 'Start Trip';
                                            mainButtonColor = Colors.red;
                                          });
                                        } else {
                                          print('else clicked');
                                          setState(() {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DropOffPage()),
                                                (route) => false);
                                          });
                                        }
                                      },
                                      child: FittedBox(
                                          child: Text(mainButtonText,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w500)))),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      Text('MORE',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),

            // This trailing comma makes auto-formatting nicer for build methods.
          ),
        ));
  }

  void acceptRideRequest() {
    print('acceptRideRequest');
    String? rideRequestId = rideDetails!.ride_request_id;

    newRequestRef
        .child(rideRequestId!)
        .child("driver_name")
        .set(driversInformation!.name);
    newRequestRef
        .child(rideRequestId)
        .child("driver_pic")
        .set(driversInformation!.pic);
    newRequestRef
        .child(rideRequestId)
        .child("driver_phone")
        .set(driversInformation!.phone);
    newRequestRef
        .child(rideRequestId)
        .child("driver_id")
        .set(driversInformation!.id);

    Map carDetails = {
      "car_name": driversInformation!.car_model,
      "car_number": driversInformation!.car_number,
      "car_color": driversInformation!.car_color
    };
    newRequestRef.child(rideRequestId).child("car_details").set(carDetails);

    Map locMap = {
      "latitude": currentPosition!.latitude.toString(),
      "longitude": currentPosition!.longitude.toString(),
    };

    newRequestRef.child(rideRequestId).child("driver_location").set(locMap);

    driverRef
        .child(currentFirebaseUser!.uid)
        .child("history")
        .child(rideRequestId)
        .set(true);
  }

  Future<void> getPlaceDirection(
      LatLng pickUpLatLng, LatLng dropOffLatLng) async {
    print("getplacedirections executed");

    var details = await AssistantMethods.obtainDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    print('this is encoded point');
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    polylinesCordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylinesCordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
          color: Colors.lightBlueAccent,
          polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          points: polylinesCordinates,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);

      polyLineSet.add(polyline);
    });

    LatLngBounds latLngBounds;

    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newRideGoogleMapControler!
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markerSet.add(pickUpLocMarker);
      markerSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      circleId: CircleId("pickUpId"),
      fillColor: Colors.white,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.yellowAccent,
    );

    Circle dropOffLocCircle = Circle(
      circleId: CircleId("dropOffId"),
      fillColor: Colors.white,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.yellowAccent,
    );

    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }

  void getRideLocationUpdated() {
    print("getRideLocationUpdate is running..................................");

    LatLng oldPos = LatLng(0, 0);

    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      print(
          "inside get position stream ---------------------------------------");
      currentPosition = position;
      myPosition = position;

      print(
          "myposition================================================= ${myPosition}");

      LatLng mPosition = LatLng(position.latitude, position.longitude);

      var rot = MapKitAssistant.getMarkerRotaion(oldPos.latitude,
          oldPos.longitude, myPosition!.latitude, myPosition!.longitude);

      print(
          'roooooot is printing yo.............................................');
      print(rot);
      print(mPosition);
      print(animatingMarkerIcon.toString());

      Marker animatingMarker = Marker(
          markerId: MarkerId("animating"),
          position: mPosition,
          icon: animatingMarkerIcon!,
          rotation: rot,
          infoWindow: InfoWindow(title: "Current Location"));

      setState(() {
        CameraPosition cameraPosition =
            new CameraPosition(target: mPosition, zoom: 17);
        newRideGoogleMapControler!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markerSet.removeWhere((marker) => marker.markerId.value == "animating");
        markerSet.add(animatingMarker);
      });
      oldPos = mPosition;
      print(
          "almost done get position stream ---------------------------------------");
      updateRideDetails();

      String? rideRequestId = rideDetails!.ride_request_id;

      Map locMap = {
        "latitude": currentPosition!.latitude.toString(),
        "longitude": currentPosition!.longitude.toString(),
      };

      newRequestRef.child(rideRequestId!).child("driver_location").set(locMap);
    });
  }

  void updateRideDetails() async {
    print(
        'executing UpdateRideDetails funcion -----------------------------------------------');

    if (isRequestingDirection == false) {
      isRequestingDirection = true;

      if (myPosition == null) {
        return;
      }

      var posLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);
      LatLng? destinationLatLng;

      if (status == "accepted") {
        destinationLatLng = rideDetails!.pickUp;
      } else {
        destinationLatLng = rideDetails!.dropOff;
      }

      var directionDetails = await AssistantMethods.obtainDirectionDetails(
          posLatLng, destinationLatLng!);

      print(
          'printing directionsDetails ---------------------------------------');
      print(directionDetails);

      if (directionDetails != null) {
        setState(() {
          durationRide = directionDetails.durationText;
          distanceRide = directionDetails.distanceText;

          double totalFareAmount = (directionDetails.distanceValue / 1000) * 50;
          fareRide = totalFareAmount.toStringAsFixed(2);
        });
      }
      isRequestingDirection == false;
    }
  }
}
