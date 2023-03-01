import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:qatra_first/screens/userProfile_screen.dart';
import '../widgets/appBar.dart';
import '../widgets/bottomNavBar.dart';
import 'favRefDetails.dart';
import 'home_screen.dart';
import 'request_screen.dart';

class favList extends StatefulWidget {
  static const String screenRoute = 'favList';

  favList({Key? key}) : super(key: key);
  @override
  State<favList> createState() => _favListState();
}

class _favListState extends State<favList> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  List<String> Favlist = [];
  var user;
  @override
  void initState() {
    super.initState();
    storeFavRevList(Favlist);
  }

  getUser() {
    user = _auth.currentUser;
  }

// method to fill the list of (Favlist) all fatovite ref
  void storeFavRevList(List<String> favRefList) async {
    getUser();
    String favRef;
    await _firestore.collection('AllFavoriteList').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        if (document['benefactor'] == user?.email) {
          setState(() {
            favRef = '${document['refID']}';
            favRefList.add(favRef);
          });
        }
      });
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
        currentIndex: 2,
        onTap: _onItemTapped,
      ),
      backgroundColor: const Color.fromARGB(255, 176, 228, 231),
      appBar: appBar(screenName: "My favorite list", fontSize: 18),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  for (int i = 0; i < Favlist.length; i++)
                    StreamBuilder<DocumentSnapshot>(
                      stream: _firestore
                          .collection('refrigerator')
                          .doc(Favlist[i])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Column(
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
                                    backgroundColor: const Color.fromARGB(
                                        255, 240, 241, 245),
                                  ),
                                  onPressed: () {
                                    //To show the details
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => favRefDetails(
                                                refId: Favlist[i])));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.location_on,
                                          color:
                                              Color.fromARGB(255, 7, 46, 48)),
                                      SizedBox(width: 9),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // refrigerator information
                                          Text(
                                            snapshot.data!['name'] as String,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Color.fromARGB(
                                                    255, 7, 113, 118)),
                                          ),
                                          Text(
                                            snapshot.data!['district']
                                                as String,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 14, 49, 51)),
                                          )
                                        ],
                                      )),
                                      SizedBox(width: 4),
                                      IconButton(
                                          // refill botton
                                          tooltip: 'click to refill',
                                          onPressed: () async {
                                            int availableCapacity = snapshot
                                                .data!['availableCapacity'];
                                            int capacity =
                                                snapshot.data!['capacity'];
                                            ////////////////////////////////////////////
                                            if (availableCapacity < capacity) {
                                              String refName = snapshot
                                                  .data!['name'] as String;
                                              String distr = snapshot
                                                  .data!['district'] as String;
                                              String ReId1 = Favlist[i];
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => request(
                                                      refName: refName,
                                                      district: distr,
                                                      refID: ReId1),
                                                ),
                                              );
                                            } else {
                                              // alert user that the Refrigerator is full now
                                              showPopUpMessage(
                                                  "Refrigerator is full",
                                                  "Refrigerator ${snapshot.data!['name']} is full now");
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: Color.fromARGB(
                                                255, 8, 101, 110),
                                          )),
                                      SizedBox(width: 1),
                                      IconButton(
                                          tooltip: 'click to delete',
                                          onPressed: () async {
                                            // delete this Refrigerator from this user fav list
                                            deleteRefFromFavList(Favlist[i]);

                                            // alert user that the Refrigerator is Deleted Sccessfully
                                            showPopUpMessage(
                                                "Deleted Sccessfully",
                                                "Refrigerator ${snapshot.data!['name']} was deleted!");
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
                          );
                        } else {
                          return Text('Loading...');
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void press() {}

  Future<void> deleteRefFromFavList(String refId) async {
    final user = _auth.currentUser;

    await _firestore.collection('AllFavoriteList').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        if (document['refID'] == refId &&
            document['benefactor'] == user?.email) {
          setState(() {
            _firestore.collection('AllFavoriteList').doc(document.id).delete();
          });
        }
      });
    });
  }

  void showPopUpMessage(String title, String body) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("$title"),
            content: Text(" $body"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => favList()));
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
