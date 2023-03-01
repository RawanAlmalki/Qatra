import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/My_button.dart';
import '../widgets/appBar.dart';
import 'adminProfile_screen.dart';
import 'admin_screen.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class addRef extends StatefulWidget {
  static const String screenRoute = 'add_ref';
  addRef({Key? key}) : super(key: key);
  @override
  State<addRef> createState() => _addRefState();
}

class _addRefState extends State<addRef> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int groupValue = 0;
  Set<Marker> markers = {
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(21.492500, 39.177570),
        visible: true)
  };
  late GoogleMapController mapController;
  var lat;
  var long;
  List<String> districtsList = [
    'Select a district',
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
  String selectedItem = 'Select a district';
  int capacity = 1;
  late String refName = "";
  var refLength = 0;

  @override
  void initState() {
    super.initState();
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
            //  activeIcon: Icon(Icons.account_circle),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            // activeIcon: Icon(Icons.home),
          ),
        ],
        currentIndex: 0,
        selectedItemColor: const Color.fromARGB(255, 176, 228, 231),
        onTap: _onItemTapped,
      ),
      backgroundColor: const Color.fromARGB(255, 176, 228, 231),
      appBar: appBar(screenName: "Add new refrigerator", fontSize: 17),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30),
                  const Text(
                    'Add new refrigerator',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 64, 165, 165),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Refrigerator name:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
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
                  Text(
                    "Select a district:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: 20,
                    child: DropdownButton<String>(
                        value: selectedItem,
                        items: districtsList
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child:
                                    Text(item, style: TextStyle(fontSize: 25))))
                            .toList(),
                        onChanged: (item) =>
                            setState(() => selectedItem = item!)),
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
                      value: capacity,
                      buttonColor: Color.fromARGB(255, 64, 165, 165),
                      onChanged: (value) => setState(() =>
                          capacity = int.parse(value.replaceAll(',', '')))),
                  SizedBox(height: 15),
                  const Text(
                    "Refrigerator row length:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      refLength = int.parse(
                        value.replaceAll(',', ''),
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter refrigerator row length in cm',
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
                        target: LatLng(21.492500, 39.177570),
                        zoom: 12,
                      ),
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      onTap: (LatLng position) {
                        print(position.latitude);
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
                            if (selectedItem == 'Select a district') {
                              showPopUpMessage(
                                  "Oh, Sorry!", "Please select a district.");
                            } else if (capacity == 0) {
                              showPopUpMessage(
                                  "Oh, Sorry!", "Please select a capacity.");
                            } else if (refName == "") {
                              showPopUpMessage("Oh, Sorry!",
                                  "Please enter a refrigerator name.");
                            } else {
                              // if everything is ok, add this refrigerator to the database
                              var result = await _firestore
                                  .collection("refrigerator")
                                  .add({
                                'name': refName,
                                'refLocation': GeoPoint(lat, long),
                                'district': selectedItem,
                                'capacity': capacity,
                                'refLength': refLength,
                                'availableCapacity': capacity,
                                'fullSensors': 0,
                              });

                              await _firestore
                                  .collection("refrigerator")
                                  .doc(result.id)
                                  .collection('sensors')
                                  .add({'sensor': "j"});

                              // alert the admin that refrigerator was added to the database
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Added Sccessfully!"),
                                      content: Text(
                                          "Refrigerator ${refName} was add Sccessfully"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        adminProfile()));
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

  void showPopUpMessage(String title, String body) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
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
