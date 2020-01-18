class Tracking {
  String title;
  String description;
  Duration currentTime;
  List<Map<String, DateTime>> history;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime timeLimit;
  DateTime reminderTime;
  bool showReminder;
  bool active = false;

  Tracking({
    this.title,
    this.description,
    DateTime createdAt,
    DateTime updatedAt,
    this.history,
    this.showReminder = true,
    DateTime timeLimit,
    DateTime reminderTime,
  }) {
    final today = DateTime.now();
    final newDate =
        DateTime.utc(today.year, today.month, today.day, 1, 0, 0, 0);

    this.currentTime = Duration.zero;
    this.createdAt = createdAt != null ? createdAt : today;
    this.updatedAt = updatedAt != null ? updatedAt : today;
    this.history = List<Map<String, DateTime>>();
    this.timeLimit = timeLimit != null ? timeLimit : newDate;
    this.reminderTime = reminderTime != null ? reminderTime : today;
  }

  Tracking.fromJson(Map<String, dynamic> json) {
    final today = DateTime.now();

    try {
      this.title = json["title"];

      this.description = json["description"];

      this.createdAt = DateTime.tryParse(json["createdAt"]);

      this.updatedAt = DateTime.tryParse(json["updatedAt"]);

      this.timeLimit = DateTime.tryParse(json["timeLimit"]);

      this.reminderTime = DateTime.tryParse(json["reminderTime"]);

      this.showReminder = json["showReminder"] as bool;

      this.history = List<Map<String, DateTime>>();

      if (json["history"].length != 0) {
        for (var h in json["history"]) {
          Map<String, DateTime> mapDate = Map<String, DateTime>();

          mapDate["startBlock"] = DateTime.tryParse(h["startBlock"]);
          mapDate["endBlock"] = DateTime.tryParse(h["endBlock"]);

          this.history.add(mapDate);
        }

        final times = this
            .history
            .where((x) =>
                today.difference(x["startBlock"]).inDays == 0 &&
                today.difference(x["endBlock"]).inDays == 0)
            .toList();

        var hours = 0;
        var minutes = 0;
        var seconds = 0;

        for (var time in times) {
          final t = time["endBlock"].difference(time["startBlock"]);
          hours += t.inHours;
          minutes += t.inMinutes;
          seconds += t.inSeconds;
        }

        final _date =
            Duration(hours: hours, minutes: minutes, seconds: seconds);

        this.currentTime = _date;
      } else {
        this.currentTime = Duration(hours: 0, minutes: 0, seconds: 0);
      }
    } catch (e) {
      print("gggg $e");
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();

    try {
      json["title"] = this.title;
      json["description"] = this.description;
      json["createdAt"] = this.createdAt.toIso8601String();
      json["updatedAt"] = this.updatedAt.toIso8601String();
      json["timeLimit"] = this.timeLimit != null
          ? this.timeLimit.toIso8601String()
          : DateTime.now().toIso8601String();
      json["reminderTime"] = this.reminderTime != null
          ? this.reminderTime.toIso8601String()
          : DateTime.now().toIso8601String();
      json["showReminder"] = this.showReminder;

      var newList = List<Map<String, dynamic>>();

      for (var h in this.history) {
        Map<String, dynamic> mapDate = Map<String, dynamic>();
        mapDate["startBlock"] = h["startBlock"].toIso8601String();
        mapDate["endBlock"] = h["endBlock"].toIso8601String();

        newList.add(mapDate);
      }

      json["history"] = newList;

      json["currentTime"] = this.currentTime.toString();
    } catch (e) {
      print(" sfsafsafsaf : ${e}");
    }

    return json;
  }
}
