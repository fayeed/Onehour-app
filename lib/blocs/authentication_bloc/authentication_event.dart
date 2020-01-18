import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:onehour/models/user.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const <dynamic>[]]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => "AppStarted";
}

class LoggedIn extends AuthenticationEvent {
  final FirebaseUser user;
  final User data;
  final bool isGuest;
  final bool isNew;

  LoggedIn({
    this.isGuest = false,
    this.isNew = false,
    this.data,
    this.user,
  });

  @override
  String toString() => "LoggedIn";
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => "LoggedOut";
}
