import 'package:flutter/material.dart';
import 'package:qatra_first/screens/addAdmin_screen.dart';
import 'package:qatra_first/screens/admin_screen.dart';
import 'package:qatra_first/screens/notifi_service.dart';
import 'package:qatra_first/screens/registration_screen.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:qatra_first/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Qatra App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: WelcomeScreen.screenRoute,
        routes: {
          WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
          logInScreen.screenRoute: (context) => logInScreen(),
          RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
          home.screenRoute: (context) => home(),
          addAdmin.screenRoute: (context) => addAdmin(),
          addAdmin.screenRoute: (context) => admin(),
        });
  }
}
