import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qatra_first/screens/adminProfile_screen.dart';
import 'package:qatra_first/screens/admin_screen.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:getwidget/getwidget.dart';
import '../widgets/appBar.dart';

class contactUsAdmin extends StatefulWidget {
  static const String screenRoute = 'contactUs';
  const contactUsAdmin({Key? key}) : super(key: key);

  @override
  State<contactUsAdmin> createState() => _contactUsAdminState();
}

class _contactUsAdminState extends State<contactUsAdmin> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  Set<Marker> markers = Set();
  late GoogleMapController mapController;

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
        appBar: appBar(screenName: "Contact Us", fontSize: 18),
        body: SafeArea(
          child: Container(
            height: 500,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GFCard(
                  title: const GFListTile(
                    title: Text(
                      'Qatra team',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 64, 165, 165),
                      ),
                    ),
                    subTitle: Text(
                      'To support you when facing any problem or to inquire more about our services, you can contact us through the following channels:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 12, 12, 12),
                      ),
                    ),
                  ),
                  boxFit: BoxFit.cover,
                  image: Image.asset(
                    'images/back.jpeg',
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                  ),
                  showImage: true,
                  buttonBar: GFButtonBar(
                    spacing: 16,
                    children: <Widget>[
                      GFIconButton(
                        tooltip: "email",
                        color: Color.fromARGB(255, 224, 43, 37),
                        onPressed: () async {
                          String email =
                              Uri.encodeComponent("qatraproject1@gmail.com");
                          String subject =
                              Uri.encodeComponent("Hello Qatra Team!");
                          Uri mail =
                              Uri.parse("mailto:$email?subject=$subject");
                          if (await launchUrl(mail)) {
                            //email app opened
                            await launchUrl(mail);
                          } else {
                            //email app is not opened
                            throw 'Could not launch $mail';
                          }
                        },
                        icon: Icon(Icons.mail),
                      ),
                      GFIconButton(
                        tooltip: "phone",
                        color: Color.fromARGB(255, 26, 193, 93),
                        onPressed: () async {
                          var sms = Uri.parse("sms:966738292");
                          if (await canLaunchUrl(sms)) {
                            await launchUrl(sms);
                          } else {
                            throw 'Could not launch $sms';
                          }
                        },
                        icon: Icon(
                          Icons.phone,
                        ),
                      ),
                      GFIconButton(
                        tooltip: "facebook",
                        color: Color.fromARGB(255, 54, 101, 210),
                        onPressed: () async {
                          var url = Uri.parse(
                              "https://www.facebook.com/profile.php?id=100090291697274&mibextid=LQQJ4d");
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        icon: Icon(Icons.facebook),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void onPressed() {}
}
