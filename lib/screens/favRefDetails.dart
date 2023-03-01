import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:qatra_first/screens/userProfile_screen.dart';

import '../widgets/appBar.dart';
import '../widgets/bottomNavBar.dart';
import 'home_screen.dart';

class favRefDetails extends StatefulWidget {
  final String refId;

  const favRefDetails({super.key, required this.refId});

  @override
  State<favRefDetails> createState() => _favRefDetailsState();
}

class _favRefDetailsState extends State<favRefDetails> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  Set<Marker> markers = Set();
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => userProfile())); //favorate list
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
          currentIndex: 2,
          onTap: _onItemTapped,
        ),
        backgroundColor: const Color.fromARGB(255, 176, 228, 231),
        appBar: appBar(screenName: "Refrigerator Information", fontSize: 18),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Container(
              color: Color.fromRGBO(254, 255, 255, 1),
              height: 380,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: _firestore
                          .collection('refrigerator')
                          .doc('${widget.refId}')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Column(children: [
                            GFListTile(
                              avatar: GFAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                shape: GFAvatarShape.standard,
                                backgroundImage:
                                    AssetImage('images/location.png'),
                              ),
                              titleText: snapshot.data!['name'] as String,
                              subTitleText: snapshot.data!['district'],
                            ),
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
                            //   showImage: true,
                            GFListTile(
                              avatar: GFAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                shape: GFAvatarShape.standard,
                                backgroundImage:
                                    AssetImage('images/carton.png'),
                              ),
                              titleText: 'The Number Of Cartons',
                              subTitleText: '${snapshot.data!['capacity']}',
                            ),
                          ]);
                        } else {
                          return Text('Loading...');
                        }
                      }),
                ),
              ),
            ),
          ),
        ));
  }
}
