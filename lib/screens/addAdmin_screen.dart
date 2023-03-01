import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qatra_first/screens/login_screen.dart';
import '../widgets/My_button.dart';
import '../widgets/appBar.dart';
import 'adminProfile_screen.dart';
import 'admin_screen.dart';

class addAdmin extends StatefulWidget {
  static const String screenRoute = 'addAdmin_screen';
  const addAdmin({super.key});

  @override
  State<addAdmin> createState() => _addAdminState();
}

class _addAdminState extends State<addAdmin> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  late String name;
  late String email;
  late String password;
  bool showSpinner = false;

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
      backgroundColor: Color.fromARGB(255, 176, 228, 231),
      appBar: appBar(screenName: "Add new Admin", fontSize: 18),
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
                    const Icon(Icons.person_add,
                        size: 100,
                        color: const Color.fromARGB(255, 64, 165, 165)),
                    SizedBox(height: 50),
                    const Text(
                      "Admin Name:",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        name = value.trim();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Admin Name',
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
                    SizedBox(height: 8),
                    const Text(
                      "Admin Email:",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value.trim();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Admin Email',
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
                    SizedBox(height: 8),
                    const Text(
                      "Admin Password:",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Admin password',
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
                    MyButton(
                      color: const Color.fromARGB(255, 64, 165, 165),
                      title: 'Save',
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });

                        try {
                          if (password == null) {
                            //display error message to enter an password
                            showPopUpMessage(
                                "Oh, Sorry!", "Please enter a password.");
                          } else if (email == null) {
                            //display error message to enter an email
                            showPopUpMessage(
                                "Oh, Sorry!", "Please enter an email.");
                          } else if (name == null) {
                            //display error message to enter a name
                            showPopUpMessage(
                                "Oh, Sorry!", "Please enter a name.");
                          } else {
                            createNewAdmin();

                            //If the new admin added, user should be alerted by sending a success message
                            successMessage(name);

                            setState(() {
                              showSpinner = false;
                            });

                            print(email);
                            print(password);
                            print(name);
                            //text page

                          }
                        } catch (e) {
                          // If any error occurs during the adding process
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Erorr"),
                                  content: Text(e.toString()),
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
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void successMessage(String name) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Added Sccessfully"),
            content: Text("You have added new admin ${name} successfully!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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

  Future<void> createNewAdmin() async {
    final newUser = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore.collection("Admin").add({
      'Password': password,
      'email': email,
      'name': name,
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
}
