import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qatra_first/screens/login_screen.dart';
import 'package:qatra_first/screens/userProfile_screen.dart';
import '../widgets/appBar.dart';
import '../widgets/bottomNavBar.dart';
import 'favRefDetails.dart';
import 'home_screen.dart';
import 'request_screen.dart';
import 'dart:async';

class favList {
  static const String screenRoute = 'favList';

  favList({required this.firestore});

  final firestore;

  Future<int> storeFavRevList(String user) async {
    List<String> Favlist = [];
    String ss;
    int i = 0;

    await firestore.collection('AllFavoriteList').get().then((snapshot) {
      snapshot.docs.forEach((document) async {
        if (document['benefactor'] == user) {
          i++;
          ss = '${document['refID']}';
          Favlist.add(ss);
        }
      });
    });
    return Future.value(i);
  }
}
