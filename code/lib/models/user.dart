class User {
  final String uid;
  User({ this.uid });
}

class CurrentUserData {
  String uid;
  String name;
  String contactNo;
  bool isRetailer;
  String preferredLanguage;
  String address;
  bool isRegistrationComplete;

  CurrentUserData({ this.uid, this.name, this.contactNo, this.isRetailer, this.preferredLanguage, this.address, this.isRegistrationComplete});
}