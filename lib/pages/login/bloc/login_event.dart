import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const <dynamic>[]]) : super(props);
}

class LoginAsGuest extends LoginEvent {
  @override
  String toString() => "LoginAsGuest";
}

class LoginAsGoogle extends LoginEvent {
  @override
  String toString() => "LoginAsGoogle";
}

class LoginAsFacebook extends LoginEvent {
  @override
  String toString() => "LoginAsFacebook";
}

class LoginAsTwitter extends LoginEvent {
  @override
  String toString() => "LoginAsTwitter";
}

class LoginAsEmail extends LoginEvent {
  LoginAsEmail({this.email, this.password});

  final String email, password;

  @override
  String toString() => "LoginAsEmail";
}

class LoginPurge extends LoginEvent {
  @override
  String toString() => "LoginPurge";
}
