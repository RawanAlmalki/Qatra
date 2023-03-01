import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:qatra_first/screens/editInfo_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/appBar.dart';
import '../widgets/bottomNavBar.dart';
import 'favList_screen.dart';
import 'home_screen.dart';
import 'contactUs.dart';
import 'notifi_service.dart';
import 'reqDetails_screen.dart';

class userProfile extends StatefulWidget {
  static const String screenRoute = 'userProfile_screen';
  userProfile({Key? key}) : super(key: key);
  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late DateTime now = DateTime.now();
  late var availableCapacity = 0;

  @override
  void initState() {
    super.initState();
    deleteOldReq();
  }

  Future<void> deleteOldReq() async {
//check request time to delete req
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('donates').get().then((snapshot) {
        snapshot.docs.forEach((document) async {
          if (user != null) {
            if (document['benefactor'] as String == user.email as String) {
              // if request time expired
              if (now
                  .isAfter((document["requestTime"] as Timestamp).toDate())) {
                var refName = "";
                await _firestore
                    .collection("refrigerator")
                    .doc(document["refId"])
                    .get()
                    .then((snapshot) => refName = snapshot["name"]);

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delivery confirmation'),
                      content: Text(
                          'Please confirm if the donation has been delivered to $refName refrigerator'),
                      actions: [
                        TextButton(
                          child: const Text('YES'),
                          onPressed: () {
                            //delete the user Request
                            _firestore
                                .collection('donates')
                                .doc(document.id)
                                .delete();
                            NotificationService().showNotification(
                                title: 'Your request is completed',
                                body: 'Thank you for your donation!',
                                id: Random().nextInt(100));
                            Navigator.of(context).pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text('NO'),
                          onPressed: () {
                            // update the available Capacity for this refrigerator
                            updateAvailableCapacity(document['refId'],
                                document['requestedCapacity']);

                            //delete the user Request
                            _firestore
                                .collection('donates')
                                .doc(document.id)
                                .delete();
                            Navigator.of(context).pop(context);

                            showPopUpMessage('Request not complete!',
                                'Sorry your request time to deliver water to $refName refrigerator has ended.');
                          },
                        )
                      ],
                    );
                  },
                );
              }
            }
          }
        });
      });
    }
  }

  updateAvailableCapacity(refID, requestedCapacity) async {
    final doc = await _firestore
        .collection("refrigerator")
        .doc(refID)
        .get()
        .then((snapshot) => availableCapacity = snapshot["availableCapacity"]);

    // update the available Capacity for this refrigerator
    final docRef = _firestore
        .collection('refrigerator')
        .doc(refID)
        .update({'availableCapacity': (availableCapacity + requestedCapacity)});
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
      appBar: appBar(screenName: "User Profile", fontSize: 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 15),
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('benefactor')
                      .where("email", isEqualTo: _auth.currentUser!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs as List<DocumentSnapshot>;
                      return ListView(
                          shrinkWrap: true,
                          children: documents
                              .map((doc) => Column(
                                    children: [
                                      Text(
                                        doc['name'],
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Color.fromARGB(255, 64, 165, 165),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        doc['email'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList());
                    } else {
                      return const Text('Loading...');
                    }
                  }),
              const SizedBox(height: 35),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: editProfileInfo,
                  child: Row(
                    children: [
                      const Icon(Icons.account_circle,
                          color: const Color.fromARGB(255, 85, 140, 143)),
                      const SizedBox(width: 20),
                      const Expanded(
                          child: const Text(
                        'Edit profile',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 85, 140, 143)),
                      )),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: const Color.fromARGB(255, 85, 140, 143),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: const Color(0xFFF5F6F9),
                  ),
                  onPressed: showFavList,
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Color.fromARGB(255, 85, 140, 143),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        'My favorite list',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 85, 140, 143)),
                      )),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: const Color.fromARGB(255, 85, 140, 143),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: const Color(0xFFF5F6F9),
                  ),
                  onPressed: showRequest,
                  child: Row(
                    children: [
                      Icon(
                        Icons.water_drop_outlined,
                        color: const Color.fromARGB(255, 85, 140, 143),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        'My request',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 85, 140, 143)),
                      )),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: const Color.fromARGB(255, 85, 140, 143),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: const Color(0xFFF5F6F9),
                  ),
                  onPressed: contactUS,
                  child: Row(
                    children: [
                      Icon(
                        Icons.help,
                        color: const Color.fromARGB(255, 85, 140, 143),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        'Help Center',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 85, 140, 143)),
                      )),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: const Color.fromARGB(255, 85, 140, 143),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void contactUS() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const contactUs()));
  }

  void editProfileInfo() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EditProfilScreen()));
  }

  void showFavList() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => favList()));
  }

  Future<void> showRequest() async {
    //retreve req id
    bool val = false;
    int capacity = 0;
    String refId = 'id';
    String date = 'date';
    final user = _auth.currentUser;

    await _firestore.collection('donates').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        if (document['benefactor'] == user?.email) {
          val = true;
          setState(() {
            capacity = document['requestedCapacity'] as int;
            refId = document['refId'];
            date = formateDate(document['requestTime']);
          });
        }
      });
    });

    if (val == false) {
      //display error message
      showPopUpMessage("Sorry!", "There is no active request !");
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  reqDetails(capacity2: capacity, refId2: refId, date2: date)));
    }
  }

  String formateDate(timeStamp) {
    var formttedDate =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat("yyyy-MM-dd").format(formttedDate);
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
