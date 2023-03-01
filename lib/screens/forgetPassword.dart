import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/My_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class forgetPassword extends StatefulWidget {
  static const String screenRoute = 'signin_screen';
  const forgetPassword({Key? key}) : super(key: key);

  @override
  __forgetPassScreenState createState() => __forgetPassScreenState();
}

class __forgetPassScreenState extends State<forgetPassword> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;

  final _emailController = TextEditingController();

  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 176, 228, 231),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: 50),
              const Text(
                'Enter your email to send you a password reset link',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  //  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 64, 165, 165),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _emailController,
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
              SizedBox(height: 8),
              MyButton(
                color: const Color.fromARGB(255, 64, 165, 165),
                title: 'Reset',
                onPressed: forgetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future forgetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      //If the user exists, it should be alerted by sending a password reset link
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Password reset link"),
              content: const Text(
                  "Password reset link is sent! Please check your email now"),
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
    } on FirebaseAuthException catch (e) {
      // If any error occurs during the password reset process
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
  }
}
