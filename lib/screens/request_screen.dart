import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qatra_first/screens/home_screen.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:qatra_first/screens/userProfile_screen.dart';
import '../widgets/My_button.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import '../widgets/appBar.dart';
import '../widgets/bottomNavBar.dart';
import 'favList_screen.dart';

class request extends StatefulWidget {
  static const String screenRoute = 'add_ref';
  final String refName;
  final String district;
  final String refID;
  const request(
      {Key? key,
      required this.refName,
      required this.district,
      required this.refID})
      : super(key: key);
  @override
  State<request> createState() => _requestState();
}

class _requestState extends State<request> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late int availableCapacity = 0;
  late int capacity = 0;
  late DateTime firestorDate;

  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  late String DaysFromNow;

  var numOfCartons = 0;
  int groupValue = 1;

  late String refName;
  @override
  void initState() {
    super.initState();
    getDynamicCap();
    getCap();
  }

  getDynamicCap() async {
    final doc = await _firestore
        .collection("refrigerator")
        .doc(widget.refID)
        .get()
        .then((snapshot) => availableCapacity = snapshot["availableCapacity"]);
    int name = doc;
    setState(() {
      availableCapacity = name;
    });
  }

  getCap() async {
    final doc = await _firestore
        .collection("refrigerator")
        .doc(widget.refID)
        .get()
        .then((snapshot) => capacity = snapshot["capacity"]);
    int name = doc;
    setState(() {
      capacity = name;
    });
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
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
        currentIndex: 1,
        onTap: _onItemTapped,
      ),
      backgroundColor: const Color.fromARGB(255, 176, 228, 231),
      appBar: appBar(screenName: "Request details to refill", fontSize: 17),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: const Color.fromARGB(255, 85, 140, 143),
                      size: 35,
                    ),
                    const SizedBox(width: 19),
                    Expanded(
                        child: Text(
                      '${widget.refName} - ${widget.district}',
                      style: const TextStyle(
                        color: const Color(0xff0d0e0e),
                        fontSize: 20.0,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  "Refrigerator capacity:",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                QuantityInput(
                  value: numOfCartons,
                  maxValue: availableCapacity,
                  minValue: 0,
                  buttonColor: Color.fromARGB(255, 64, 165, 165),
                  onChanged: (value) => setState(
                    () => numOfCartons = int.parse(
                      value.replaceAll(',', ''),
                    ),
                  ),
                ),
                const SizedBox(height: 27),
                const Text(
                  "Choose delivery method:",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    GFRadio(
                      size: GFSize.SMALL,
                      value: 1,
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value;
                          firestorDate =
                              DateTime.now().add(const Duration(days: 1));
                        });
                      },
                      inactiveIcon: null,
                      activeBorderColor: GFColors.SUCCESS,
                      radioColor: GFColors.SUCCESS,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "By myself",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 17),
                    GFRadio(
                      size: GFSize.SMALL,
                      value: 2,
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value;
                          firestorDate =
                              DateTime.now().add(const Duration(days: 3));
                        });
                      },
                      inactiveIcon: null,
                      activeBorderColor: GFColors.SUCCESS,
                      radioColor: GFColors.SUCCESS,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "By delivery company",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                groupValue == 1
                    ? GFListTile(
                        icon: const Icon(Icons.timer_outlined),
                        color: GFColors.WHITE,
                        titleText: 'Time to refill',
                        subTitleText:
                            "From $now to ${DaysFromNow = DateFormat("yyyy-MM-dd").format(DateTime.now().add(new Duration(days: 1)))}",
                      )
                    : GFListTile(
                        color: GFColors.WHITE,
                        titleText: 'Time to refill',
                        subTitleText:
                            'From $now to ${DaysFromNow = DateFormat("yyyy-MM-dd").format(DateTime.now().add(new Duration(days: 3)))}',
                        icon: const Icon(Icons.timer_outlined)),
                groupValue == 2
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 21),
                          const Text(
                            "Water delivery companies:",
                            style: TextStyle(
                              fontSize: 19,
                            ),
                          ),
                          Wrap(children: [
                            Row(
                              children: [
                                IconButton(
                                  iconSize: 88,
                                  icon: Image.asset('images/nova.png'),
                                  onPressed: () {
                                    showCompanyInfo("Nova Company Information",
                                        "\nTell: 920033445\n\nWebSite: https://novawater.com/layout/home");
                                  },
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  iconSize: 90,
                                  icon: Image.asset('images/berain.png'),
                                  onPressed: () {
                                    showCompanyInfo(
                                        "Berain Company Information",
                                        "\nTell: 920025555\n\nWebSite: https://berain.com.sa/oms/address/choose");
                                  },
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  iconSize: 90,
                                  icon: Image.asset('images/moya.png'),
                                  onPressed: () {
                                    showCompanyInfo("Moya Company Information",
                                        "\nTell: 0590011888\n\nWebSite: https://www.moyaapp.com/ar/home");
                                  },
                                ),
                              ],
                            ),
                          ]),
                        ],
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: MyButton(
                        color: Color.fromARGB(255, 64, 165, 165),
                        title: 'Save',
                        onPressed: () async {
                          final user = _auth.currentUser;

                          // check if user has select the number of cartons to refill
                          if (numOfCartons == 0) {
                            showPopUpMessage("Oh, Sorry!",
                                "Please select the number of cartons to refill !");
                          } else {
                            // if everything is okay, accept the request & add it to firebase
                            createDonationRequest(user);

                            updateNumOfDonations(user);

                            updateAvailableCapacity(availableCapacity);

                            showSuccessMessage("Request!",
                                "Your Request Is complete. Thank you for your donation!");
                          }
                        },
                      ),
                    ),
                    MyButton(
                      color: const Color.fromARGB(255, 223, 45, 13),
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
    );
  }

  Future showCompanyInfo(name, website) => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${name}"),
          content: Text("${website}"),
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

  void showSuccessMessage(String title, String body) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => home()));
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

  Future<void> updateAvailableCapacity(availableCapacity) async {
    // Subtract the required number of cartons from the currently available capacity,
    // and check whether the result of the subtraction is 0
    availableCapacity = availableCapacity - numOfCartons;
    if (availableCapacity == 0) {
      // This means refrigerator capacity is full and all the cartons it needs have been donated to it
      // return available Capacity back to the original Capacity
      availableCapacity = capacity;
      await _firestore.collection('refrigerator').doc(widget.refID).update(
          // Save the modified data back to the database
          {'availableCapacity': capacity});
    } else {
      // This means we still did not cover refrigerator capacity, so only update the available Capacity
      await _firestore
          .collection('refrigerator')
          .doc(widget.refID)
          .update({'availableCapacity': availableCapacity});
    }
  }

  void updateNumOfDonations(user) async {
    await _firestore.collection('benefactor').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        if (document['email'] == user?.email) {
          var currentDonations = document['donations'];
          await _firestore
              .collection('benefactor')
              .doc(document.id)
              .update({'donations': currentDonations + 1});
        }
      });
    });
  }

  Future<void> createDonationRequest(User? user) async {
    await _firestore.collection("donates").add({
      if (user != null) 'benefactor': user.email,
      'refId': widget.refID,
      'requestTime': firestorDate,
      'requestedCapacity': numOfCartons,
    });
  }
}
