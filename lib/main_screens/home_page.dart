import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Assistance/assistanceMethods.dart';
import '../Models/direactionDetails.dart';
import '../Notifications/pushNotificationService.dart';
import '../Verifications/dialog_box/issue_homepage_box.dart';
import '../config.dart';
import '../main.dart';
import '../providers/appData.dart';
import '../secondprio_screens/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKEY = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController? newGoogleMapControler;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  bool warningMain = false;

  Color switchColor = Colors.grey;
  bool onlineDriver = false;
  String todayDay = 'N/A';
  String todayDate = 'N/A';

  String driverName = 'Best Driver';

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  DirectionDetails? tripDirectionDetails;
  bool isDriverAvailable = false;

  PushNotificationService pushee = PushNotificationService();

  void mapInitialized(GoogleMapController controller) {
    print('google map controller called');
    _controllerGoogleMap.complete(controller);
    newGoogleMapControler = controller;
  }

  @override
  void initState() {
    print('home page is called');
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    firebaseUser = currentFirebaseUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int tokenInt = int.parse(driversInformation!.token);
    if (driversInformation!.pstatus != 'ACTIVE') {
      print('you are not verified');
      warningMain = true;
    } else if (tokenInt < 2) {
      print('tokens are less then 2');
      warningMain = true;
    }
    homepageDate();
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey.shade800,
            title: Text('Home'),
            centerTitle: true,
            bottom: TabBar(
              onTap: (index) {
                print('online');
                // makeDriverOnlineNow();
              },
              indicatorColor: Colors.grey.shade800,
              tabs: [
                Tab(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        int tokenInt = int.parse(driversInformation!.token);
                        if (driversInformation!.pstatus != 'ACTIVE') {
                          print('you are not verified');
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) =>
                                  IssueHomePage());
                        } else if (tokenInt < 2) {
                          print('tokens are less then 2');
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) =>
                                  IssueHomePage());
                        } else {
                          if (onlineDriver == false) {
                            onlineDriver = true;
                            switchColor = Colors.greenAccent;
                            print('making driver online');

                            makeDriverOnlineNow();
                          } else {
                            switchColor = Colors.grey;
                            onlineDriver = false;
                            makeDriverOfflineNow();
                          }
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      width: 90,
                      height: 40,
                      child: warningMain
                          ? Icon(
                              Icons.warning,
                              size: 30,
                              color: Colors.yellow,
                            )
                          : Image.asset(
                              'assets/power-button.png',
                            ),
                      decoration: BoxDecoration(
                          border: Border.all(color: switchColor, width: 3),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                )
              ],
            ),
            actions: [
              Icon(Icons.notifications),
            ],
          ),
          backgroundColor: Colors.green.shade500,
          key: _scaffoldKEY,
          drawer: AppDrawer(),
          body: SafeArea(
              child: Stack(
            children: [
              GoogleMap(
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: _kGooglePlex,
                  zoomGesturesEnabled: true,
                  polylines: polylineSet,
                  markers: markersSet,
                  circles: circlesSet,
                  padding: EdgeInsets.only(bottom: 20),
                  onMapCreated: (GoogleMapController controller) {
                    _controllerGoogleMap.complete(controller);
                    newGoogleMapControler = controller;
                    getCurrentLocation();
                  }),
              Positioned(
                  top: 300,
                  right: 10,
                  child: Container(
                      height: 60,
                      child: Card(
                        child: IconButton(
                          icon: Icon(Icons.my_location),
                          color: Colors.green,
                          iconSize: 35,
                          onPressed: () async {
                            getCurrentLocation();
                          },
                        ),
                      ))),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.grey.shade800.withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: Offset(0, 7), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Token',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade700,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '${driversInformation!.token} active',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$todayDay',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '$todayDate',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade300),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          )

              // This trailing comma makes auto-formatting nicer for build methods.
              ),
        ));
  }

  void getCurrentLocation() async {
    print('GetCurrent Lcoation executed');

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // currentPosition = position;

    print('GetCurrent  executed');
    LatLng currentPosition = LatLng(position.latitude, position.longitude);
    print('GetCurrent Lcoation ');
    CameraPosition cameraPositionuser =
        new CameraPosition(target: currentPosition, zoom: 14);

    newGoogleMapControler!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPositionuser));
    String address =
        await AssistantMethods().searchCoordinateAddress(position, context);

    print('your address yo bellow' ' :: ${address}');

    print("currentFirebaseUser 00000000000000000000000000000000");
    print(currentFirebaseUser);
    print("currentFirebaseUser 00000000000000000000000000000000");
  }

  Future<void> getPlaceDirection() async {
    print("getplacedirections executed");
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLapLng = LatLng(initialPos!.latitude, initialPos.longitude);
    var dropOffLapLng = LatLng(finalPos!.latitude, finalPos.longitude);
    print("getsinitial values");

    var details = await AssistantMethods.obtainDirectionDetails(
        pickUpLapLng, dropOffLapLng);

    setState(() {
      tripDirectionDetails = details;
    });

    print('this is encoded point');
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
          color: Colors.lightBlueAccent,
          polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;

    if (pickUpLapLng.latitude > dropOffLapLng.latitude &&
        pickUpLapLng.longitude > dropOffLapLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLapLng, northeast: pickUpLapLng);
    } else if (pickUpLapLng.longitude > dropOffLapLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLapLng.latitude, dropOffLapLng.longitude),
          northeast: LatLng(dropOffLapLng.latitude, pickUpLapLng.longitude));
    } else if (pickUpLapLng.latitude > dropOffLapLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLapLng.latitude, pickUpLapLng.longitude),
          northeast: LatLng(pickUpLapLng.latitude, dropOffLapLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLapLng, northeast: dropOffLapLng);
    }

    newGoogleMapControler!
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: "Current Location"),
      position: pickUpLapLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "Destination"),
      position: dropOffLapLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      circleId: CircleId("pickUpId"),
      fillColor: Colors.white,
      center: pickUpLapLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.yellowAccent,
    );

    Circle dropOffLocCircle = Circle(
      circleId: CircleId("dropOffId"),
      fillColor: Colors.white,
      center: dropOffLapLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.yellowAccent,
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }

  void makeDriverOnlineNow() async {
    rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRide");

    print('rideRequest Reference value =   ${rideRequestRef.key}');

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    currentPosition = position;

    print("inside makeDriverOnlineNow-----------------------------------");
    print(currentFirebaseUser);
    Geofire.initialize("availableDrivers");
    Geofire.setLocation(firebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
    rideRequestRef.set('searching');
    rideRequestRef.onValue.listen((event) {});

    pushee.showNotificationDialog(context);
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;

      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentFirebaseUser!.uid, position.latitude, position.longitude);
      }

      LatLng latlang = LatLng(position.latitude, position.longitude);
      newGoogleMapControler!.animateCamera(CameraUpdate.newLatLng(latlang));
    });
  }

  void makeDriverOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    print(rideRequestRef.key);
    rideRequestRef.onDisconnect();
    rideRequestRef.set('offline');
    print('your are offline-----------------------------------------');
    print(rideRequestRef.key);
  }

  void homepageDate() {
    List months = [
      "January",
      "Febuary",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    final date = DateTime.now();
    todayDay = DateFormat('EEEE').format(date).toString();
    todayDate = '${date.day}  ${months[date.month]}';
  }
}
