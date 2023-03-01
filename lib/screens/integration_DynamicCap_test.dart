





class DynamicCap {
  DynamicCap({required this.firestore});
  final firestore;
  num availableCapacity = 0;

  Future<num?> getDynamicCap(String refID) async {
    await firestore
        .collection("refrigerator")
        .doc(refID)
        .get()
        .then((snapshot) => availableCapacity = snapshot["availableCapacity"]);
        return availableCapacity;
  }
}
