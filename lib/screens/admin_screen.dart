import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/appBar.dart';
import 'adminProfile_screen.dart';
import 'login_screen.dart';
import 'package:custom_info_window/custom_info_window.dart';

/// not a core function
class admin extends StatefulWidget {
  static const String screenRoute = 'admin_screen';
  const admin({Key? key}) : super(key: key);

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  final _firestore = FirebaseFirestore.instance;
  final _realtime = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;
  late int sensorNum = 0;
  late int fullSensors = 0;
  late var flag = false;
  Set<Marker> markers = Set();
  late GoogleMapController mapController;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();

    _firestore.collection('refrigerator').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        String name = document['name'];
        int avCap = document['availableCapacity'] as int;
        int cap = document['capacity'] as int;
        double latitude = document['refLocation'].latitude;
        double longitude = document['refLocation'].longitude;
        int refLength = document['refLength'] as int;
        int numOfFullSensors = document['fullSensors'] as int;

        sensorData(numOfFullSensors, document.id, refLength);
        checkIfempty(document.id);

        if (flag == true || avCap < cap) {
          // View empty refrigerators with red color
          markers.add(Marker(
            markerId: MarkerId(document.id),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: name,
            ),
          ));
        } else {
          // View filled refrigerators with green color
          markers.add(Marker(
            markerId: MarkerId(document.id),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(
              title: name,
            ),
          ));
        }
      });

      setState(() {});
    });
  }

  void sensorData(numOfFullSensors, id, refLength) async {
    DocumentReference document2 = _firestore.collection('refrigerator').doc(id);

    document2.collection('sensors').get().then((snapshot) async {
      snapshot.docs.forEach((document) {
        setState(() {
          sensorNum++;
        });

        _realtime.child('${document['r']}').get().then((snapshot) async {
          final dataSnapshot = snapshot.value;
          if (dataSnapshot! != null) {
            int state = dataSnapshot as int;
            if (refLength > state) {
              fullSensors = numOfFullSensors + 1;
              await document2.update({'fullSensors': fullSensors});
            }
          }
        });
      });
    });
  }

  checkIfempty(id) async {
    DocumentReference document2 = _firestore.collection('refrigerator').doc(id);
    DocumentSnapshot t = await document2.get();
    int fullsensors = await t.get('fullSensors');
    double showRef = (fullsensors / sensorNum) * 100;

    if (showRef > 50) {
      flag = false;
      document2.update({'fullSensors': 0});
    } else if (showRef < 50) {
      document2.update({'fullSensors': 0});
      flag = true;
    }
  }

// to move to other pages FROM the bottom navigation bar
  void _onItemTapped(int index) {
    final user = _auth.currentUser;
    if (user != null) {
      if (index == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => adminProfile()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const admin()));
      }
    } else {
      Navigator.pushNamed(context, logInScreen.screenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 85, 140, 143),
        iconSize: 25,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: const Color.fromARGB(255, 176, 228, 231),
        onTap: _onItemTapped,
      ),
      backgroundColor: const Color.fromARGB(255, 176, 228, 231),
      appBar: appBar(screenName: "View Refrigerators", fontSize: 18),
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(21.492500, 39.177570),
              zoom: 12,
            ),
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) {
              _customInfoWindowController.googleMapController = controller;
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 170,
            width: 260,
            offset: 50,
          ),
        ],
      ),
    );
  }

  void onPressed() {}
}
