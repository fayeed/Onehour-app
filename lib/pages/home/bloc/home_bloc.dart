import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:onehour/models/tracking.dart';
import 'package:onehour/repositories/user_repository.dart';
import 'package:onehour/utils/ticker.dart';
import './bloc.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final List<Tracking> data;
  final FirebaseAnalytics analytics;
  final FlutterLocalNotificationsPlugin notification;

  List<Tracking> trackingList = List<Tracking>();
  int active = -1;
  Ticker ticker;
  int edit = -1;
  DateTime startBlock;
  DateTime endBlock;
  int i = 0;
  bool showNotification = true;
  bool isNew = false;

  StreamSubscription<Duration> _tickerSubscription;

  @override
  HomeState get initialState => super.initialState ?? HomeState.empty();

  HomeBloc({
    this.userRepository,
    this.data,
    this.analytics,
    this.notification,
  });

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is StartTimerEvent) {
      yield* _mapStartTimerEvent(event.pos);
    } else if (event is TickTimerEvent) {
      yield* _mapTickTimerEvent(event.time);
    } else if (event is StopTimerEvent) {
      yield* _mapStopTimerEvent();
    } else if (event is AddTimerEvent) {
      yield* _mapAddTimerEvent(
        title: event.title,
        description: event.description,
      );
    } else if (event is IsNewTimerEvent) {
      yield* _mapIsNewTimerEvent(event.isNew);
    } else if (event is EditTimerEvent) {
      yield* _mapEditTimerEvent(pos: event.pos);
    } else if (event is PurgeHomeStateEvent) {
      yield* _mapPrugeHomeStateEvnet();
    } else if (event is UpdateTimerEvent) {
      yield* _mapUpdateTimerEvent(event);
    } else if (event is ToggleTimerNotificationEvent) {
      yield* _mapToggleNotificationTimerEvent(event);
    } else if (event is DeleteTimerEvent) {
      yield* _mapDeleteTimerEvent(event);
    }
  }

  Stream<HomeState> _mapStartTimerEvent(int pos) async* {
    if (active != -1 && ticker != null) {
      trackingList[active].active = false;

      ticker.stop();
    }

    startBlock = DateTime.now();

    active = pos;

    trackingList[active].active = true;

    _tickerSubscription?.cancel();

    isNew = false;

    ticker = Ticker(startTime: trackingList[pos].currentTime)..start();

    _tickerSubscription = ticker.currentDuration.stream
        .listen((duration) => dispatch(TickTimerEvent(time: duration)));

    yield HomeState.updateTime(
      tracking: trackingList,
      active: pos,
      isNew: isNew,
      showNotification: showNotification,
    );

    analytics.logEvent(name: "start_timer", parameters: {
      "title": trackingList[pos].title,
      "current_time": trackingList[pos].currentTime.toString(),
    });
  }

  Stream<HomeState> _mapTickTimerEvent(Duration time) async* {
    trackingList[active].currentTime = time;

    yield HomeState.updateTime(
      tracking: trackingList,
      active: active,
      edit: edit,
      isNew: isNew,
      showNotification: showNotification,
    );
  }

  Stream<HomeState> _mapStopTimerEvent() async* {
    if (active != -1) {
      ticker.stop();
    }

    _tickerSubscription?.cancel();

    endBlock = DateTime.now();

    trackingList[active]
        .history
        .add({"startBlock": startBlock, "endBlock": endBlock});

    analytics.logEvent(name: "stop_timer", parameters: {
      "title": trackingList[active].title,
      "current_time": trackingList[active].currentTime.toString(),
    });

    startBlock = null;
    endBlock = null;

    trackingList[active].active = false;

    active = -1;

    yield HomeState.updateTime(
      tracking: trackingList,
      active: active,
      edit: edit,
      isNew: false,
      showNotification: showNotification,
    );

    Map<String, dynamic> json = Map<String, dynamic>();

    json["trackingList"] = trackingList.map((t) => t.toJson()).toList();

    await userRepository.updateTrackingList(json);
  }

  Stream<HomeState> _mapAddTimerEvent({String title, description}) async* {
    if (active != -1) {
      ticker.stop();
    }

    final tracking = Tracking(
      title: title,
      description: description,
    );

    final newTrackingList = [...trackingList, tracking];

    trackingList = newTrackingList;

    // * Previous
    if (active != -1) {
      trackingList[active].active = false;
    }

    active = trackingList.length - 1;

    // * New
    trackingList[active].active = true;

    edit = active;

    isNew = false;

    _tickerSubscription?.cancel();

    startBlock = DateTime.now();

    ticker = Ticker(startTime: trackingList[active].currentTime)..start();

    _tickerSubscription = ticker.currentDuration.stream
        .listen((duration) => dispatch(TickTimerEvent(time: duration)));

    yield HomeState.updateTime(
      tracking: trackingList,
      active: active,
      isNew: isNew,
      edit: edit,
      showNotification: showNotification,
    );

    final date = trackingList[edit].reminderTime;

    var time = new Time(date.hour, date.minute, date.second);

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'repeatDailyAtTime channel for onehour tasks',
      'repeatDailyAtTime channel name for onenour',
      'repeatDailyAtTime description',
    );

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );

    await notification.showDailyAtTime(
      edit,
      'Reminder for ${trackingList[edit].title}',
      "Daily limit set for this task is ${trackingList[edit].timeLimit.hour}:${trackingList[edit].timeLimit.minute}:${trackingList[edit].timeLimit.second} if you don't to receive new notification you can turn them off.",
      time,
      platformChannelSpecifics,
    );

    Map<String, dynamic> json = Map<String, dynamic>();

    json["trackingList"] = trackingList.map((t) => t.toJson()).toList();

    userRepository
        .updateTrackingList(json)
        .then((v) => print("saved"))
        .catchError((onError) => print(onError));

    analytics.logEvent(name: "timer_added", parameters: {"title": title});
  }

  Stream<HomeState> _mapIsNewTimerEvent(bool newValue) async* {
    isNew = newValue;

    yield HomeState.updateTime(
      tracking: trackingList,
      active: active,
      isNew: newValue,
      edit: -1,
    );

    analytics.logEvent(name: "new_timer_intent");
  }

  Stream<HomeState> _mapEditTimerEvent({int pos}) async* {
    edit = pos;

    yield HomeState.updateTime(
      tracking: trackingList,
      active: active,
      isNew: false,
      edit: pos,
      showNotification: showNotification,
    );

    analytics.logEvent(name: "edit_timer_intent", parameters: {
      "title": trackingList[pos].title,
      "current_time": trackingList[pos].currentTime.toString(),
    });
  }

  // * Not logging any event here because it will fire a lot of times
  // * might result in very huge data spike here
  Stream<HomeState> _mapUpdateTimerEvent(UpdateTimerEvent event) async* {
    trackingList[edit].title = event.title ?? trackingList[edit].title;
    trackingList[edit].description =
        event.description ?? trackingList[edit].description;
    trackingList[edit].timeLimit =
        event.timeLimit ?? trackingList[edit].timeLimit;
    trackingList[edit].showReminder =
        event.showReminder ?? trackingList[edit].showReminder;
    trackingList[edit].reminderTime =
        event.reminderTime ?? trackingList[edit].reminderTime;

    if (event.showReminder != null || event.reminderTime != null) {
      notification.cancel(edit);

      if (trackingList[edit].showReminder) {
        final date = trackingList[edit].reminderTime;

        var time = new Time(date.hour, date.minute, date.second);

        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'repeatDailyAtTime channel for onehour tasks',
          'repeatDailyAtTime channel name for onenour',
          'repeatDailyAtTime description',
        );

        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

        var platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics,
          iOSPlatformChannelSpecifics,
        );

        await notification.showDailyAtTime(
          edit,
          'Reminder for ${trackingList[edit].title}',
          "Daily limit set for this task is ${trackingList[edit].timeLimit.hour}:${trackingList[edit].timeLimit.minute}:${trackingList[edit].timeLimit.second} if you don't to receive new notification you can turn them off.",
          time,
          platformChannelSpecifics,
        );
      }
    }

    yield HomeState.updateTime(
      tracking: trackingList,
      edit: edit,
      active: active,
      isNew: false,
      showNotification: showNotification,
    );
  }

  Stream<HomeState> _mapPrugeHomeStateEvnet() async* {
    yield HomeState.empty();
  }

  Stream<HomeState> _mapToggleNotificationTimerEvent(
      ToggleTimerNotificationEvent event) async* {
    showNotification = event.showNotification;

    yield HomeState.updateTime(
      tracking: trackingList,
      edit: edit,
      active: active,
      isNew: false,
      showNotification: event.showNotification,
    );

    if (event.showNotification) {
      final androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel for onehour tasks',
        'repeatDailyAtTime channel name for onenour',
        'repeatDailyAtTime description',
      );

      final iOSPlatformChannelSpecifics = new IOSNotificationDetails();

      final platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics,
        iOSPlatformChannelSpecifics,
      );
      var i = 0;

      for (var track in trackingList) {
        final date = track.reminderTime;

        var time = new Time(date.hour, date.minute, date.second);

        notification.showDailyAtTime(
          i,
          'Reminder for ${track.title}',
          "Daily limit set for this task is ${track.timeLimit.hour}:${track.timeLimit.minute}:${track.timeLimit.second} if you don't to receive new notification you can turn them off.",
          time,
          platformChannelSpecifics,
        );

        i++;
      }
    } else {
      notification.cancelAll();
    }

    analytics.logEvent(
      name: "all_notification_toggle",
      parameters: {
        "active": event.showNotification,
      },
    );
  }

  Stream<HomeState> _mapDeleteTimerEvent(DeleteTimerEvent event) async* {
    final itemNo = event.itemNo;

    if (active == itemNo) {
      ticker.stop();

      _tickerSubscription?.cancel();
    }

    startBlock = null;

    endBlock = null;

    active = -1;

    edit = -1;

    trackingList.removeAt(itemNo);

    yield HomeState.updateTime(
      tracking: trackingList,
      active: active,
      edit: edit,
      isNew: false,
      showNotification: showNotification,
    );

    analytics.logEvent(name: "item_removed");

    Map<String, dynamic> json = Map<String, dynamic>();

    json["trackingList"] = trackingList.map((t) => t.toJson()).toList();

    await userRepository.updateTrackingList(json);
  }

  @override
  HomeState fromJson(Map<String, dynamic> json) {
    List<Tracking> newList = List<Tracking>();

    if (data == null) {
      for (var t in json["trackingList"]) {
        final a = Tracking.fromJson(t);

        newList.add(a);
      }

      trackingList = newList;
    } else {
      trackingList = data;
    }

    showNotification = json["showNotification"] as bool;

    return HomeState(
      trackingList: trackingList,
      active: active,
      isNew: true,
      edit: -1,
      showNotification: showNotification,
    );
  }

  @override
  Map<String, dynamic> toJson(HomeState state) {
    Map<String, dynamic> json = Map<String, dynamic>();

    json["trackingList"] = state.trackingList.map((t) => t.toJson()).toList();
    json["showNotification"] = state.showNotification;

    return json;
  }
}
