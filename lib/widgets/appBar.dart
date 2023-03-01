import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qatra_first/screens/login_screen.dart';

class appBar extends StatelessWidget with PreferredSizeWidget {
  appBar({required this.screenName, required this.fontSize});

  final String screenName;
  final double fontSize;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 85, 140, 143),
      title: Row(
        children: [
          Image.asset('images/droplet.jpg', height: 25),
          const SizedBox(width: 10),
          Text('${screenName}',
              style: TextStyle(
                fontSize: fontSize,
              ))
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            final user = _auth.currentUser;
            if (user != null) {
              _auth.signOut();
              Navigator.pushNamed(context, logInScreen.screenRoute);
            } else {
              Navigator.pushNamed(context, logInScreen.screenRoute);
            }
          },
          icon: const Icon(Icons.logout_outlined),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
