



class Capacity {
  Capacity({required this.firestore});
  final firestore;
  num capacity = 0;

  Future<num?> getCap(refID) async {
    await firestore
        .collection("refrigerator")
        .doc(refID)
        .get()
        .then((snapshot) => capacity = snapshot["capacity"]);
    return capacity;
  }
}
