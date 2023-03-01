import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class editRefInfo {
  editRefInfo({required this.firestore});

  final firestore;

  Future<bool?> updateRefInfo(
      refId, newName, newDistrict, newCapacity, lat, long) async {
    // Modify the data with the new value entered by the user
    // get document refrence for this refrigerator
    final docRef = firestore.collection('refrigerator').doc(refId);
    if (newName != "") {
      docRef.update(
          // Save the modified data back to the database
          {'name': newName});
      return Future.value(true);
    }

    if (newDistrict != "") {
      docRef.update(
          // Save the modified data back to the database
          {'district': newDistrict});
      return Future.value(true);
    }

    if (newCapacity != "") {
      docRef.update(
          // Save the modified data back to the database
          {'capacity': newCapacity});
      return Future.value(true);
    }

    if (lat != "" && long != "") {
      docRef.update(
          // Save the modified data back to the database
          {'refLocation': GeoPoint(lat, long)});
      return Future.value(true);
    }
    if (newName != "" || newDistrict != "" || newCapacity != "" || lat != "") {
      // The user should be alerted that the data in updated Sccessfully now
      return Future.value(true);
    }
  }
}
