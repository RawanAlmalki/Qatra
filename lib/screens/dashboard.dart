import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qatra_first/screens/login_screen.dart';
import '../widgets/appBar.dart';
import 'adminProfile_screen.dart';
import 'admin_screen.dart';

class dashboard extends StatefulWidget {
  static const String screenRoute = 'dashboard';
  static String docId = "";

  dashboard({Key? key}) : super(key: key);
  @override
  State<dashboard> createState() => _dashboardState();
}

class Statistics {
  final String title;
  final int number;

  Statistics({
    required this.title,
    required this.number,
  });
}

class _dashboardState extends State<dashboard> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final List<Statistics> statistics = [];
  var Donations = 0;
  var numOfRef = 0;
  var numOfBenef = 0;

  @override
  void initState() {
    super.initState();
    getBenefactorsInfo();
    getRefrigeratorsInfo();
  }

// get benefactors Statistics
  void getBenefactorsInfo() async {
    final user = _auth.currentUser;
    await _firestore.collection('benefactor').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        setState(() {
          numOfBenef++;
          Donations = document['donations'] + Donations;
        });
      });
    });
    statistics.add(Statistics(
      title: "Donations number",
      number: Donations,
    ));

    statistics.add(Statistics(
      title: "Total number \nof benefactors",
      number: numOfBenef,
    ));
  }

// get refrigerators Statistics
  void getRefrigeratorsInfo() async {
    final user = _auth.currentUser;
    await _firestore.collection('refrigerator').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        setState(() {
          numOfRef++;
        });
      });
    });

    statistics.add(Statistics(
      title: "Total number \nof refrigerator",
      number: numOfRef,
    ));
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
      appBar: appBar(screenName: "Dashboard", fontSize: 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              GridView.builder(
                itemCount: statistics.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15,
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    mainAxisSpacing: 20),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 113, 171, 174),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            statistics[index].title,
                            maxLines: 2,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 237, 239, 240),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                width: 7,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 59, 110, 112),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              Text(
                                '${statistics[index].number}',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 249, 249, 249),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void press() {}
}
