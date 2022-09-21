import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hale_a_taxi/config.dart';
import 'package:hale_a_taxi/ride_request_pages/payment_page.dart';
import 'package:hale_a_taxi/secondprio_screens/app_drawer.dart';

import '../Assistance/assistanceMethods.dart';
import '../Assistance/mapKitAssistant.dart';
import '../config.dart';
import '../main.dart';

class DropOffPage extends StatefulWidget {
  const DropOffPage({Key? key}) : super(key: key);
  @override
  State<DropOffPage> createState() => _DropOffPageState();
}

class _DropOffPageState extends State<DropOffPage> {
  GlobalKey<ScaffoldState> _scaffoldKEY = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController? newGoogleMapControler;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void mapInitialized(GoogleMapController controller) {
    print('google map controller called');
    _controllerGoogleMap.complete(controller);
    newGoogleMapControler = controller;
  }

  GoogleMapController? newRideGoogleMapControler;
  StreamSubscription<Position>? rideStreamSubscriptionDropPage;

  Color mainButtonColor = Colors.green;
  String mainButtonText = 'End Ride';
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
  void initState() {
    rideStarted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'DROP OFF',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.withOpacity(0.8)),
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
                              'Drop-Off Location',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: screenWidth / 1.5,
                                  child: Text(
                                    '${rideDetails!.dropoff_address}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth / 30,
                                ),
                                Icon(
                                  Icons.location_on,
                                  size: 30,
                                  color: Colors.greenAccent,
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
                                  Text(
                                    'PROMO',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            rideDetails!.referral_code == true
                                                ? Colors.green
                                                : Colors.red),
                                  ),
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
                              var pickUpLatLang = rideDetails!.pickUp;
                              var dropOffLatLang = rideDetails!.dropOff;
                              await getPlaceDirection(
                                  pickUpLatLang!, dropOffLatLang!);
                              getRideLocationUpdated();
                            }),
                        //padding: EdgeI
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
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                vertical: 16,
                                                horizontal: screenWidth / 4.3)),
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(fontSize: 20))),
                                    onPressed: () {
                                      endTheTrip();
                                    },
                                    child: Text(mainButtonText,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500))),
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

  void rideStarted() {
    print('acceptRideRequest');
    String? rideRequestId = rideDetails!.ride_request_id;
    newRequestRef.child(rideRequestId!).child("status").set('onride');

    Map locMap = {
      "latitude": currentPosition!.latitude.toString(),
      "longitude": currentPosition!.longitude.toString(),
    };

    newRequestRef.child(rideRequestId).child("driver_location").set(locMap);
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

    rideStreamSubscriptionDropPage =
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

  endTheTrip() {
    String? rideRequestId = rideDetails!.ride_request_id;
    newRequestRef.child(rideRequestId!).child("status").set('ended');

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PaymentPage()),
        (route) => false);
  }
}
