import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:onehour/models/user.dart';

class LoginState {
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;
  final bool isGuest;
  final bool isNew;
  final FirebaseUser user;
  final User data;

  LoginState(
      {@required this.isSuccess,
      @required this.isFailure,
      @required this.isLoading,
      @required this.isGuest,
      @required this.isNew,
      @required this.data,
      @required this.user});

  factory LoginState.empty() {
    return LoginState(
      isFailure: false,
      isSuccess: false,
      isLoading: false,
      isGuest: false,
      isNew: false,
      user: null,
      data: null,
    );
  }

  factory LoginState.loading({bool isGuest = false}) {
    return LoginState(
      isFailure: false,
      isSuccess: false,
      isLoading: true,
      isGuest: isGuest,
      isNew: false,
      user: null,
      data: null,
    );
  }

  factory LoginState.sucess({
    bool isGuest = false,
    isNew = false,
    FirebaseUser user,
    User data,
  }) {
    return LoginState(
      isFailure: false,
      isSuccess: true,
      isLoading: false,
      isGuest: isGuest,
      isNew: true,
      user: user,
      data: data,
    );
  }

  factory LoginState.failure({bool isGuest = false}) {
    return LoginState(
      isFailure: true,
      isSuccess: false,
      isLoading: false,
      isGuest: isGuest,
      isNew: false,
      user: null,
      data: null,
    );
  }
}
