import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:qatra_first/screens/userProfile_screen.dart';
import 'package:getwidget/getwidget.dart';
import '../widgets/appBar.dart';
import '../widgets/bottomNavBar.dart';
import 'favList_screen.dart';
import 'home_screen.dart';

class reqDetails extends StatefulWidget {
  static const String screenRoute = 'contactUs';

  final int capacity2;
  final String refId2;
  final String date2;

  const reqDetails(
      {Key? key,
      required this.capacity2,
      required this.refId2,
      required this.date2})
      : super(key: key);

  @override
  State<reqDetails> createState() => _reqDetailsState();
}

class _reqDetailsState extends State<reqDetails> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  Set<Marker> markers = Set();
  late GoogleMapController mapController;
  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

  @override
  void initState() {
    super.initState();
  }

// to move to other pages FROM the bottom navigation bar
  void _onItemTapped(int index) {
    final user = _auth.currentUser;

    if (index == 0) {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => userProfile()));
      } else {
        Navigator.pushNamed(context, logInScreen.screenRoute);
      }
    } else if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const home()));
    } else {
      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => favList())); //favorate list
      } else {
        Navigator.pushNamed(context, logInScreen.screenRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: bottomNavBar(
          currentIndex: 0,
          onTap: _onItemTapped,
        ),
        backgroundColor: const Color.fromARGB(255, 176, 228, 231),
        appBar: appBar(screenName: "My Request", fontSize: 18),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Container(
              color: const Color.fromARGB(255, 254, 255, 255),
              height: 450,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: _firestore
                          .collection('refrigerator')
                          .doc('${widget.refId2}')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Column(children: [
                            GFListTile(
                              avatar: const GFAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                shape: GFAvatarShape.standard,
                                backgroundImage:
                                    AssetImage('images/location.png'),
                              ),
                              titleText: snapshot.data!['name'] as String,
                              subTitleText: snapshot.data!['district'],
                            ),

                            // location of the refrigerator to donate forS
                            Container(
                              width: 350,
                              height: 200,
                              child: GoogleMap(
                                markers: markers = {
                                  Marker(
                                      markerId: MarkerId('1'),
                                      position: LatLng(
                                          snapshot
                                              .data!['refLocation'].latitude,
                                          snapshot
                                              .data!['refLocation'].longitude),
                                      visible: true)
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      snapshot.data!['refLocation'].latitude,
                                      snapshot.data!['refLocation'].longitude),
                                  zoom: 15,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  mapController = controller;
                                },
                              ),
                            ),

                            // Remaining Time To Refill
                            GFListTile(
                              avatar: const GFAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                shape: GFAvatarShape.standard,
                                backgroundImage: AssetImage('images/time.png'),
                              ),
                              titleText: 'Remaining Time To Refill',
                              subTitleText:
                                  'From: ${now} \nTo: ${widget.date2}',
                            ),

                            // The Number Of Cartons to donate with
                            GFListTile(
                              avatar: const GFAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                shape: GFAvatarShape.standard,
                                backgroundImage:
                                    AssetImage('images/carton.png'),
                              ),
                              titleText: 'The Number Of Cartons',
                              subTitleText: '${widget.capacity2}',
                            ),
                          ]);
                        } else {
                          return const Text('Loading...');
                        }
                      }),
                ),
              ),
            ),
          ),
        ));
  }

  void onPressed() {}
}
