import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const <dynamic>[]]) : super(props);
}

class StartTimerEvent extends HomeEvent {
  StartTimerEvent({this.pos});

  final int pos;

  @override
  String toString() => "StartTimerEvent";
}

class PauseTimerEvent extends HomeEvent {
  @override
  String toString() => "PauseTimerEvent";
}

class StopTimerEvent extends HomeEvent {
  @override
  String toString() => "StopTimerEvent";
}

class ResumeTimerEvent extends HomeEvent {
  @override
  String toString() => "ResumeTimerEvent";
}

class ResetTimerEvent extends HomeEvent {
  @override
  String toString() => "ResetTimerEvent";
}

class TickTimerEvent extends HomeEvent {
  TickTimerEvent({this.time});

  final Duration time;

  @override
  String toString() => "TickTimerEvent";
}

class AddTimerEvent extends HomeEvent {
  AddTimerEvent({
    this.title,
    this.description,
  });

  final String title;
  final String description;

  @override
  String toString() => "AddTimerEvent";
}

class IsNewTimerEvent extends HomeEvent {
  IsNewTimerEvent({
    this.isNew = false,
  });

  final bool isNew;

  @override
  String toString() => "IsNewTimerEvent";
}

class EditTimerEvent extends HomeEvent {
  EditTimerEvent({this.pos});

  final int pos;

  @override
  String toString() => "EditTimerEvent";
}

class UpdateTimerEvent extends HomeEvent {
  UpdateTimerEvent({
    this.title,
    this.description,
    this.reminderTime,
    this.showReminder,
    this.timeLimit,
  });

  final String title;
  final String description;
  final DateTime timeLimit;
  final bool showReminder;
  final DateTime reminderTime;

  @override
  String toString() => "EditTimerEvent";
}

class PurgeHomeStateEvent extends HomeEvent {
  @override
  String toString() => "PurgeHomeStateEvent";
}

class ToggleTimerNotificationEvent extends HomeEvent {
  final bool showNotification;

  ToggleTimerNotificationEvent({this.showNotification});

  @override
  String toString() => "ToggleTimerNotificationEvent";
}

class DeleteTimerEvent extends HomeEvent {
  final int itemNo;

  DeleteTimerEvent({this.itemNo});

  @override
  String toString() => "DeleteTimerEvent";
}
