import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:onehour/models/user.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const <dynamic>[]]) : super(props);
}

class Unintialized extends AuthenticationState {
  @override
  String toString() => "Unintialized";
}

class Authenticated extends AuthenticationState {
  Authenticated({
    this.user,
    this.isGuest = false,
    this.isNew = false,
    data,
    this.autoLogin = false,
  }) : this.data = data != null ? data : User.initial();

  final FirebaseUser user;
  final bool isGuest, isNew, autoLogin;
  final User data;

  @override
  String toString() => "Authenticated";
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => "Unauthenticated";
}
