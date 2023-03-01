import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qatra_first/screens/flag.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:qatra_first/screens/userProfile_screen.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:getwidget/getwidget.dart';
import '../widgets/appBar.dart';
import '../widgets/bottomNavBar.dart';
import 'favList_screen.dart';
import 'request_screen.dart';
import 'notifi_service.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';

class home extends StatefulWidget {
  static const String screenRoute = 'auth_screen';
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final _firestore = FirebaseFirestore.instance;
  final _realtime = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;
  late String refname = 's';
  late String distr = 'w';
  late String RefId = 'a';
  late int sensorNum = 0;
  int fullSensors = 0;

  List<String> Favlist = [];
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  late User signedInUser;
  Set<Marker> markers = Set();
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      sendNotification(Favlist);
    }

    _firestore.collection('refrigerator').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        DocumentReference document2 =
            _firestore.collection('refrigerator').doc(document.id);
        int refLength = document['refLength'] as int;
        int numOfFullSensors = document['fullSensors'] as int;

        sensorData(numOfFullSensors, document.id, refLength);
        checkIfempty(document2.id);

        int avCap = document['availableCapacity'] as int;
        int cap = document['capacity'] as int;
        double latitude = document['refLocation'].latitude;
        double longitude = document['refLocation'].longitude;
        if (flag == true || avCap < cap) {
          markers.add(Marker(
            markerId: MarkerId(document.id),
            position: LatLng(latitude, longitude),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  StreamBuilder<DocumentSnapshot>(
                    stream: document2.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Wrap(children: [
                          GFCard(
                            borderRadius: BorderRadius.circular(29),
                            boxFit: BoxFit.fill,
                            padding: EdgeInsets.all(0),
                            title: GFListTile(
                              avatar: const GFAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                shape: GFAvatarShape.standard,
                                backgroundImage:
                                    AssetImage('images/location.png'),
                              ),
                              title: Text(
                                snapshot.data!['name'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subTitle:
                                  Text(snapshot.data!['district'] as String),
                            ),
                            buttonBar: GFButtonBar(
                              alignment: WrapAlignment.end,
                              children: <Widget>[
                                GFButton(
                                  onPressed: () async {
                                    if (user != null) {
                                      bool val = true;
                                      await _firestore
                                          .collection('donates')
                                          .get()
                                          .then((snapshot) {
                                        snapshot.docs.forEach((document) async {
                                          if (user != null) {
                                            if (document['benefactor']
                                                    as String ==
                                                user.email as String) {
                                              val = false;
                                            }
                                          }
                                        });
                                      });
                                      if (val == true) {
                                        //If user don't have active Request
                                        refname =
                                            snapshot.data!['name'] as String;
                                        distr = snapshot.data!['district']
                                            as String;
                                        RefId = document.id;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => request(
                                                refName: refname,
                                                district: distr,
                                                refID: RefId),
                                          ),
                                        );
                                      } else {
                                        //If user already have active Request
                                        showUnAcceptableRequestMessage();
                                      }
                                    } else {
                                      Navigator.pushNamed(
                                          context, logInScreen.screenRoute);
                                    }
                                  },
                                  text: "Refill",
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  color:
                                      const Color.fromARGB(255, 85, 140, 143),
                                ),
                                GFButton(
                                  onPressed: () async {
                                    final user = _auth.currentUser;
                                    if (user != null) {
                                      refname = snapshot.data!['name'];
                                      distr = snapshot.data!['district'];
                                      RefId = document.id;
                                      // 1-check if it is already in favList
                                      bool val =
                                          false; //this ref not in fav list

                                      await _firestore
                                          .collection('AllFavoriteList')
                                          .get()
                                          .then((snapshot) {
                                        snapshot.docs.forEach((document) async {
                                          if (document['benefactor'] ==
                                                  user?.email &&
                                              document['refID'] == RefId) {
                                            val = true;
                                          }
                                        });
                                      });

                                      // 2-if yes, message window to display the rejection of adding
                                      if (val == true) {
                                        rejectionMessage(refname);
                                      }

                                      // 3-if no, adding it to donates collection with success message
                                      else {
                                        addToFavList(RefId, user?.email);
                                        //If the Refrigerator added Sccessfully, user should be alerted by sending a Sccessfull message
                                        successMessage(refname);
                                      }
                                    } else {
                                      Navigator.pushNamed(
                                          context, logInScreen.screenRoute);
                                    }
                                  },
                                  text: "Favorite",
                                  icon: const Icon(
                                    Icons.favorite_rounded,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  color:
                                      const Color.fromARGB(255, 85, 140, 143),
                                ),
                              ],
                            ),
                          ),
                        ]);
                      } else {
                        return Text('Loading...');
                      }
                    },
                  ),
                  LatLng(latitude, longitude));
            },
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

// method to send Notification for all empty refrigerators in the user fatovite list
  void sendNotification(List<String> favRefList) async {
    final user = _auth.currentUser;
    String refId;
    // get all fatovite refrigerators
    await _firestore.collection('AllFavoriteList').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        if (document['benefactor'] == user?.email) {
          setState(() {
            refId = '${document['refID']}';
            favRefList.add(refId);
          });
        }
      });
    });

    // send Notification for only empty refrigerators
    for (var i = 0; i < favRefList.length; i++) {
      await _firestore.collection('refrigerator').get().then((snapshot) {
        snapshot.docs.forEach((document) async {
          if (document.id == favRefList[i]) {
            int avCap = document['availableCapacity'] as int;
            int cap = document['capacity'] as int;
            int refLength = document['refLength'] as int;
            int numOfFullSensors = document['fullSensors'] as int;

            sensorData(numOfFullSensors, document.id, refLength);
            checkIfempty(document.id);
            // if the refrigerator is empty send Notification
            if (flag == true || avCap < cap) {
              NotificationService().showNotification(
                  title: 'Empty refrigerator',
                  body:
                      '${document['name']} refrigerator is empty, refill it now!',
                  id: Random().nextInt(100));
            }
          }
        });
      });
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => favList())); //favorate list
      } else {
        Navigator.pushNamed(context, logInScreen.screenRoute);
      }
    }
  }

  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: bottomNavBar(
        currentIndex: 1,
        onTap: _onItemTapped,
      ),
      backgroundColor: const Color.fromARGB(255, 176, 228, 231),
      appBar: appBar(screenName: "View empty refrigerators", fontSize: 18),
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            initialCameraPosition: const CameraPosition(
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
            width: 280,
            offset: 38,
          ),
          const GFAccordion(
              title: 'Click on any empty refrigerator',
              content:
                  'To refill any empty refrigerator or add it to your favorites list, you can simply click on it in the map to view its information and benefit from our services.')
        ],
      ),
    );
  }

  void onPressed() {}

  void rejectionMessage(String refname) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Adding to favorate list!"),
            content: Text(
                "Refrigerator ${refname} already exist in your favorite list !"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child: const Text("OK"),
                ),
              ),
            ],
          );
        });
  }

  Future<void> addToFavList(String refId, String? benfactorEmail) async {
    await _firestore.collection("AllFavoriteList").add({
      'benefactor': benfactorEmail,
      'refID': refId,
    });
  }

  void successMessage(String refname) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Adding to favorate list!"),
            content: Text(
                "Refrigerator ${refname} has been added to the favorite successfully !"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child: const Text("OK"),
                ),
              ),
            ],
          );
        });
  }

  void showUnAcceptableRequestMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Not Acceptable Request!"),
            content: const Text("You have an Active request!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child: const Text("OK"),
                ),
              ),
            ],
          );
        });
  }
}
