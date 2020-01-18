import 'package:onehour/models/tracking.dart';

class User {
  String email;
  bool isGuest;
  bool isNew;
  List<Tracking> trackingList;
  String uid;
  String displayName;

  User.initial({
    this.displayName = "",
    this.email = "",
    this.isGuest = false,
    this.isNew = false,
    this.uid = "",
  }) : trackingList = List<Tracking>();

  User.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    isGuest = json["isGuest"] as bool;
    isNew = json["isNew"] as bool;
    uid = json["uid"];
    displayName = json["displayName"];

    List<Tracking> newTrackingList = List<Tracking>();

    if (json["trackingList"] != null) {
      for (final t in json["trackingList"]) {
        Map<String, dynamic> newT = Map<String, dynamic>.from(t);

        newTrackingList.add(Tracking.fromJson(newT));
      }
    }

    trackingList = newTrackingList;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();

    json["email"] = email;
    json["isGuest"] = isGuest;
    json["isNew"] = isNew;
    json["uid"] = uid;
    json["displayName"] = displayName;
    json["trackingList"] = trackingList.map((t) => t.toJson()).toList();

    return json;
  }
}
