import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qatra_first/screens/forgetpassword.dart';
import 'package:qatra_first/screens/registration_screen.dart';
import '../widgets/My_button.dart';
import 'package:qatra_first/screens/home_screen.dart';
import 'package:qatra_first/screens/admin_screen.dart';

class logInScreen extends StatefulWidget {
  static const String screenRoute = 'login_screen';
  const logInScreen({Key? key}) : super(key: key);

  @override
  _logInScreenState createState() => _logInScreenState();
}

class _logInScreenState extends State<logInScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String email;
  late String password;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 176, 228, 231),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 180,
                    child: Image.asset('images/droplet.jpg'),
                  ),
                  Column(children: [
                    Text(
                      'Qatra',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 64, 165, 165),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  const Text(
                    "Email:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: const InputDecoration(
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
                  SizedBox(height: 13),
                  const Text(
                    "Password:",
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
                      hintText: 'Enter your password',
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
                  const SizedBox(height: 10),
                  MyButton(
                    color: Color.fromARGB(255, 64, 165, 165),
                    title: 'Log In',
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });

                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);

                        bool val = false;
                        await _firestore
                            .collection('Admin')
                            .get()
                            .then((snapshot) {
                          snapshot.docs.forEach((document) async {
                            if (document['email'] == email) {
                              val = true;
                            }
                          });
                        });

                        if (user != null) {
                          if (val == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => admin()));
                          } else {
                            Navigator.pushNamed(context, home.screenRoute);
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } catch (e) {
                        // If any error occurs during the log in process
                        showErorrMessage();
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t you have an account?  ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                          child: new Text(
                            'Sign up now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()))),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: InkWell(
                        child: new Text(
                          'Forget password?',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => forgetPassword()))),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: InkWell(
                        child: new Text(
                          'Continue without account',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 40, 116, 111),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => home()))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showErorrMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Oh, Sorry!"),
            content: const Text(
                "The password or email is invalid, please try again.."),
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
