import 'package:flutter/material.dart';
import 'package:qatra_first/screens/home_screen.dart';
import 'package:qatra_first/screens/login_screen.dart';
import '../widgets/My_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  static const String screenRoute = 'registration_screen';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String name;
  late String email;
  late String password;
  bool showSpinner = false;

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
                    const Text(
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
                    "Name:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      name = value.trim();
                    },
                    decoration: const InputDecoration(
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
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Email:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value.trim();
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
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Password:",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                          color: Colors.blue,
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
                    color: Color.fromARGB(255, 64, 165, 165),
                    title: 'Sign Up',
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });

                      // Create new user account
                      createNewAccount();

                      setState(() {
                        showSpinner = false;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Do you have an account?  ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                          child: new Text(
                            'Log in',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => logInScreen()))),
                    ],
                  ),
                  SizedBox(height: 15),
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

  void showErorrMessage(e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Oh, Sorry!"),
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

  Future<void> createNewAccount() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _firestore.collection("benefactor").add({
        'name': name,
        'email': email,
        'password': password,
        'donations': 0,
      });
      // If the user Registered Sccessfully, it should be alerted by sending a Sccessfull message
      successMessage();
    } catch (e) {
      // If any error occurs during the registeration process
      showErorrMessage(e);
    }
  }

  void successMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Registered Sccessfully"),
            content: const Text("You have been registered successfully!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, home.screenRoute);
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
