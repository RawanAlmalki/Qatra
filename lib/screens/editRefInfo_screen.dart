import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:qatra_first/screens/editOrDeleteRef.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/My_button.dart';
import '../widgets/appBar.dart';
import 'adminProfile_screen.dart';
import 'admin_screen.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class editRefInfo extends StatefulWidget {
  static const String screenRoute = 'editRefInfo_screen';
  //////
  final String refId;
  const editRefInfo({Key? key, required this.refId}) : super(key: key);
  //////
  @override
  State<editRefInfo> createState() => _editRefInfoState();
}

class _editRefInfoState extends State<editRefInfo> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Set<Marker> markers = {};
  late GoogleMapController mapController;
  var lat;
  var long;
  List<String> districtsList = [
    'Al-Murjan',
    'Al-Basateen',
    'Al-Mohamadiya',
    'Ash-Shati',
    'Ar-Rabwa',
    'As-Safa',
    'Al-Faysaliya',
    'Al-Andalus',
    'King Abdul Al-Aziz University',
    'Al-Hamraa',
    'Al-Ajwad',
    'As-Samer',
    'Al-Salhiya',
    'Bab Makkah',
    'Al-Hindawiya',
    'Al-Balad',
  ];
  String? newDistrict;
  late int newCapacity;
  late String newName;
  var _nameController = TextEditingController();
  late LatLng location;
  late String refName;

  @override
  void initState() {
    super.initState();
    getRefInfo();
  }

//get ref old data
  getRefInfo() {
    _firestore.collection('refrigerator').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        final user = await _auth.currentUser;
        if (user != null) {
          if (widget.refId == document.id) {
            _nameController = TextEditingController(text: document['name']);
            newCapacity = document['capacity'];
            newDistrict = document['district'];
            markers = {
              Marker(
                  markerId: MarkerId('1'),
                  position: LatLng(document['refLocation'].latitude,
                      document['refLocation'].longitude),
                  visible: true)
            };
            location = LatLng(document['refLocation'].latitude,
                document['refLocation'].longitude);
          }
        }
      });
      setState(() {});
    });
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
        currentIndex: 0,
        selectedItemColor: const Color.fromARGB(255, 176, 228, 231),
        onTap: _onItemTapped,
      ),
      backgroundColor: const Color.fromARGB(255, 176, 228, 231),
      appBar: appBar(screenName: "Edit refrigerator information", fontSize: 17),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30),
                  const Center(
                    child: Text(
                      'Edite refrigerator information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 64, 165, 165),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  const Text(
                    "Refrigerator name:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      refName = value.trim();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter refrigerator name',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 64, 165, 165),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 64, 165, 165),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  const Text(
                    "Select a district:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: 20,
                    child: DropdownButton<String>(
                        value: newDistrict,
                        items: districtsList
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child:
                                    Text(item, style: TextStyle(fontSize: 22))))
                            .toList(),
                        onChanged: (item) =>
                            setState(() => newDistrict = item)),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    "Refrigerator capacity:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  QuantityInput(
                      value: newCapacity,
                      buttonColor: const Color.fromARGB(255, 64, 165, 165),
                      onChanged: (value) => setState(() =>
                          newCapacity = int.parse(value.replaceAll(',', '')))),
                  SizedBox(height: 20),
                  const Text(
                    "Please tap on the refrigerator location:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    width: 200,
                    child: GoogleMap(
                      markers: markers,
                      initialCameraPosition: CameraPosition(
                        target: location,
                        zoom: 12,
                      ),
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      onTap: (LatLng position) {
                        markers.remove(Marker(
                          markerId: MarkerId('1'),
                        ));
                        markers.add(Marker(
                          markerId: MarkerId('1'),
                          position: position,
                        ));
                        lat = position.latitude;
                        long = position.longitude;
                        setState(() {});
                      },
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: MyButton(
                          color: Color.fromARGB(255, 64, 165, 165),
                          title: 'Save',
                          onPressed: () async {
                            _firestore
                                .collection('refrigerator')
                                .get()
                                .then((snapshot) {
                              snapshot.docs.forEach((document) async {
                                if (widget.refId == document.id) {
                                  // Modify the data with the new values entered by the user
                                  updateRefInfo(document.id);

                                  if (refName != "" ||
                                      newDistrict != "" ||
                                      newCapacity != "" ||
                                      lat != "") {
                                    // The user should be alerted that the data in updated Sccessfully now
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Update Sccessfully"),
                                            content: const Text(
                                                "Refrigerator information has been updated successfully!"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              adminProfile()));
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(14),
                                                  child: const Text("OK"),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                }
                              });
                            });
                          },
                        ),
                      ),
                      MyButton(
                        color: Color.fromARGB(255, 223, 45, 13),
                        title: 'Cancel',
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateRefInfo(refId) async {
    // get document refrence for this refrigerator
    final docRef = _firestore.collection('refrigerator').doc(refId);
    if (refName != "") {
      docRef.update(
          // Save the modified data back to the database
          {'name': refName});
    }

    if (newDistrict != "") {
      docRef.update(
          // Save the modified data back to the database
          {'district': newDistrict});
    }

    if (newCapacity != "") {
      docRef.update(
          // Save the modified data back to the database
          {'capacity': newCapacity});
    }

    if (lat != "" && long != "") {
      docRef.update(
          // Save the modified data back to the database
          {'refLocation': GeoPoint(lat, long)});
    }
  }
}
