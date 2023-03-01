import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:qatra_first/screens/userProfile_screen.dart';
import '../widgets/My_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qatra_first/screens/home_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/appBar.dart';
import '../widgets/bottomNavBar.dart';
import 'favList_screen.dart';

class EditProfilScreen extends StatefulWidget {
  static const String screenRoute = 'editInfo_screen';
  const EditProfilScreen({Key? key}) : super(key: key);

  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  var _textControllerName = TextEditingController();
  var _textControllerEmail = TextEditingController();

  // Get the currently authenticated user
  @override
  void initState() {
    super.initState();
    _firestore.collection('benefactor').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        final user = await _auth.currentUser;
        if (user != null) {
          var email = user.email;
          if (email == document['email']) {
            String name = document['name'];
            _textControllerName = TextEditingController(text: name);
            _textControllerEmail = TextEditingController(text: email);
          }
        }
      });
      setState(() {});
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
      backgroundColor: Color.fromARGB(255, 176, 228, 231),
      bottomNavigationBar: bottomNavBar(
        currentIndex: 0,
        onTap: _onItemTapped,
      ),
      appBar: appBar(screenName: "Edit Profile", fontSize: 18),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(children: [
                      Text(
                        'Edit profile',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 64, 165, 165),
                        ),
                      ),
                    ]),
                    SizedBox(height: 50),
                    Text(
                      "Name:",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _textControllerName,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your Name',
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
                    SizedBox(height: 15),
                    Text(
                      "Email:",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _textControllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your Email',
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
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: MyButton(
                            color: Color.fromARGB(255, 64, 165, 165),
                            title: 'Save',
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              _firestore
                                  .collection('benefactor')
                                  .get()
                                  .then((snapshot) {
                                snapshot.docs.forEach((document) async {
                                  String email = document['email'];
                                  final user = await _auth.currentUser;
                                  if (user != null) {
                                    var currentEmail = user.email;

                                    if (email == currentEmail) {
                                      // Modify the data with the new value entered by the user
                                      String newName =
                                          _textControllerName.text.trim();
                                      String newEmail =
                                          _textControllerEmail.text.trim();
                                      //get document id for this user
                                      var id = document.id;
                                      final docRef = _firestore
                                          .collection('benefactor')
                                          .doc(id);
                                      if (newName != "") {
                                        docRef.update(
                                            // Save the modified data back to the database
                                            {'name': newName});
                                      }

                                      if (newEmail != "") {
                                        docRef.update(
                                            // Save the modified data back to the database
                                            {'email': newEmail});
                                        await user.updateEmail(newEmail);
                                      }
                                      if (newName != "" || newEmail != "") {
                                        // The user should be alerted that the data in updated now
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Update Sccessfully"),
                                                content: const Text(
                                                    "Your information has been updated successfully!"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pushNamed(
                                                          context,
                                                          userProfile
                                                              .screenRoute);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14),
                                                      child: const Text("OK"),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      }
                                    }
                                  }
                                });
                              });
                              setState(() {
                                showSpinner = false;
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
      ),
    );
  }
}
