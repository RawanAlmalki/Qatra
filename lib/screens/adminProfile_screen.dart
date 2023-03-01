import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qatra_first/screens/admin_screen.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:qatra_first/screens/addAdmin_screen.dart';
import 'package:qatra_first/screens/dashboard.dart';
import '../widgets/appBar.dart';
import 'addRef_screen.dart';
import 'contactUs.dart';
import 'contactUsAdmin.dart';
import 'editOrDeleteRef.dart';

/// not a core function

class adminProfile extends StatefulWidget {
  static const String screenRoute = 'adminProfile_screen';
  adminProfile({Key? key}) : super(key: key);
  @override
  State<adminProfile> createState() => _adminProfileState();
}

class _adminProfileState extends State<adminProfile> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late bool isMainAdmin = false;
  @override
  void initState() {
    final user = _auth.currentUser;

    if (user?.email == 'admin@gmail.com') {
      isMainAdmin = true;
    }
    super.initState();
  }

// to move to other pages FROM the bottom navigation bar
  void _onItemTapped(int index) {
    final user = _auth.currentUser;

    if (index == 0) {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => adminProfile()));
      } else {
        Navigator.pushNamed(context, logInScreen.screenRoute);
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const admin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _selectedIndex = 0;

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
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 176, 228, 231),
        onTap: _onItemTapped,
      ),
      backgroundColor: const Color.fromARGB(255, 176, 228, 231),
      appBar: appBar(screenName: "Admin Profile", fontSize: 18),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 15),
              StreamBuilder(
                  stream: _firestore
                      .collection('Admin')
                      .where("email", isEqualTo: _auth.currentUser!.email)
                      .snapshots(),
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
                                      Text(
                                        doc['name'],
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Color.fromARGB(255, 64, 165, 165),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        doc['email'],
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList());
                    } else {
                      return Text('Loading...');
                    }
                  }),
              SizedBox(height: 35),
              isMainAdmin == true
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Color(0xFFF5F6F9),
                        ),
                        onPressed: add_Admin,
                        child: Row(
                          children: [
                            Icon(Icons.person_add,
                                color: const Color.fromARGB(255, 85, 140, 143)),
                            SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              'Add Admin',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 85, 140, 143)),
                            )),
                            Icon(Icons.arrow_forward_ios,
                                color: const Color.fromARGB(255, 85, 140, 143)),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: dashboard_screen,
                  child: Row(
                    children: [
                      Icon(Icons.signal_cellular_alt,
                          color: const Color.fromARGB(255, 85, 140, 143)),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        'Dashboard',
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
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: addNewRef,
                  child: Row(
                    children: [
                      Icon(Icons.add,
                          color: const Color.fromARGB(255, 85, 140, 143)),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        'Add refrigerator',
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
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: editOrdelete,
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: const Color.fromARGB(255, 85, 140, 143),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        'Edit refrigerator',
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
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: helpInfo,
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

  void editOrdelete() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => editOrDeleteRef()));
  }

  void addNewRef() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => addRef()));
  }

  void helpInfo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => contactUsAdmin()));
  }

  void add_Admin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => addAdmin()));
  }

  void dashboard_screen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => dashboard()));
  }
}
