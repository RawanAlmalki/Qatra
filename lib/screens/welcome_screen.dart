import 'package:flutter/material.dart';
import 'package:qatra_first/screens/registration_screen.dart';
import 'package:qatra_first/screens/login_screen.dart';
import '../widgets/My_button.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 176, 228, 231),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              child: Image.asset('images/droplet.jpg'),
            ),
            Column(
              children: [
                Text(
                  'Qatra',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 64, 165, 165)!,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            MyButton(
              color: Color.fromARGB(255, 64, 165, 165),
              //Color.fromARGB(255, 16, 180, 202)!,
              title: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, logInScreen.screenRoute);
              },
            ),
            MyButton(
              color: Color.fromARGB(255, 64, 165, 165)!,
              title: 'Sign Up',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.screenRoute);
              },
            ),
            SizedBox(height: 20),
            Center(
              child: InkWell(
                  child: const Text(
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
    );
  }
}
