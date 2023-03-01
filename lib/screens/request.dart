import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class request {
  request({required this.firestore});

  final firestore;
  late num numOfCartons;
  num capacity = 19;
  num availableCapacity = 10;

  static const String screenRoute = 'add_ref';

  Future<num?> updateAvailableCapacity(refID, numOfCartons) async {
    // Subtract the required number of cartons from the currently available capacity,
    // and check whether the result of the subtraction is 0
    availableCapacity = availableCapacity - numOfCartons;
    if (availableCapacity == 0) {
      // This means refrigerator capacity is full and all the cartons it needs have been donated to it
      await firestore
          .collection('refrigerator')
          .doc(refID)
          .update({'state': 'filled'});

      // return available Capacity back to the original Capacity
      availableCapacity = capacity;
      await firestore.collection('refrigerator').doc(refID).update(
          // Save the modified data back to the database
          {'availableCapacity': capacity});

      return Future.value(availableCapacity);
    } else {
      // This means we still did not cover refrigerator capacity, so only update the available Capacity
      await firestore
          .collection('refrigerator')
          .doc(refID)
          .update({'availableCapacity': availableCapacity});
      return Future.value(availableCapacity);
    }
  }
}
