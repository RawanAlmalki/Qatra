import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qatra_first/screens/admin_screen.dart';
import 'package:qatra_first/screens/login_screen.dart';

import '../widgets/appBar.dart';
import 'adminProfile_screen.dart';
import 'editRefInfo_screen.dart';

class editOrDeleteRef extends StatefulWidget {
  static const String screenRoute = 'editOrDeleteRef';
  static String docId = "";

  editOrDeleteRef({Key? key}) : super(key: key);
  @override
  State<editOrDeleteRef> createState() => _editOrDeleteRefState();
}

class _editOrDeleteRefState extends State<editOrDeleteRef> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  ///////////
  String passedVal = "refId";
  ////////////
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
      appBar: appBar(screenName: "Edit refrigerator", fontSize: 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 15),
              StreamBuilder(
                  stream: _firestore.collection('refrigerator').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs;
                      return ListView(
                          shrinkWrap: true,
                          children: documents
                              .map((doc) => Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(20),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            backgroundColor:
                                                const Color(0xFFF5F6F9),
                                          ),
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Icon(Icons.location_on,
                                                  color: Color.fromARGB(
                                                      255, 7, 46, 48)),
                                              SizedBox(width: 9),

                                              //ref information
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    doc['name'],
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Color.fromARGB(
                                                            255, 85, 140, 143)),
                                                  ),
                                                  Text(
                                                    doc['district'],
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 7, 46, 48)),
                                                  )
                                                ],
                                              )),
                                              SizedBox(width: 4),

                                              // edit botton
                                              IconButton(
                                                  tooltip: 'click to edit',
                                                  onPressed: () {
                                                    passedVal = doc.id;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                editRefInfo(
                                                                    ///////
                                                                    refId:
                                                                        passedVal)));
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Color.fromARGB(
                                                        255, 97, 96, 96),
                                                  )),

                                              // delete botton
                                              IconButton(
                                                  tooltip: 'click to delete',
                                                  onPressed: () {
                                                    deleteRef(doc.id);
                                                    deleteMessage(doc['name']);
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Color.fromARGB(
                                                        255, 219, 48, 48),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList());
                    } else {
                      return const Text('Loading...');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void press() {}

  void deleteMessage(refName) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Deleted Sccessfully"),
            content: Text("Refrigerator ${refName} was delete!"),
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

  void deleteRef(String id) {
    _firestore.collection("refrigerator").doc(id).delete();
  }
}
