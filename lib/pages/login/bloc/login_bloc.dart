import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:onehour/models/user.dart';
import 'package:onehour/repositories/user_repository.dart';
import './bloc.dart';

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final FirebaseAnalytics analytics;

  LoginBloc({
    this.userRepository,
    this.analytics,
  });

  @override
  LoginState get initialState => super.initialState ?? LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginAsGuest) {
      yield* _mapLoginAsGuestToState();
    } else if (event is LoginAsGoogle) {
      yield* _mapLoginAsGoogleToState();
    } else if (event is LoginAsFacebook) {
      yield* _mapLoginAsFacebookToState();
    } else if (event is LoginAsEmail) {
      yield* _mapLoginAsEmailToState(
        email: event.email,
        password: event.password,
      );
    } else if (event is LoginPurge) {
      yield* _mapLoginPurge();
    }
  }

  Stream<LoginState> _mapLoginAsGuestToState() async* {
    try {
      yield LoginState.loading(isGuest: true);

      await userRepository.signInAsGuest();

      yield LoginState.sucess(isGuest: true, isNew: true);

      analytics.logEvent(name: "logged_in", parameters: {
        "isGuest": true,
        "isNew": true,
      });
    } catch (e) {
      yield LoginState.failure(isGuest: true);
    }
  }

  Stream<LoginState> _mapLoginAsEmailToState({String email, password}) async* {
    try {
      yield LoginState.loading(isGuest: true);

      await userRepository.signInWithEmail(email: email, password: password);

      yield LoginState.sucess(isGuest: false, isNew: true);

      analytics.logEvent(name: "logged_in", parameters: {
        "isGuest": false,
        "isNew": true,
      });
    } catch (e) {
      yield LoginState.failure(isGuest: true);
    }
  }

  Stream<LoginState> _mapLoginAsGoogleToState() async* {
    yield LoginState.loading(isGuest: false);

    final result = await userRepository.signInWithGoogle();

    if (result["error"] == null) {
      final user = result["user"];
      final User data = result["data"];

      yield LoginState.sucess(
        isGuest: false,
        user: user,
        data: data,
        isNew: data.isNew,
      );

      analytics.logEvent(name: "logged_in", parameters: {
        "isGuest": true,
        "isNew": true,
      });
    } else {
      yield LoginState.failure(isGuest: false);
    }
  }

  Stream<LoginState> _mapLoginAsFacebookToState() async* {
    try {
      yield LoginState.loading(isGuest: false);

      await userRepository.signInWithFacebook();

      yield LoginState.sucess(isGuest: false);

      analytics.logEvent(name: "logged_in", parameters: {
        "isGuest": true,
        "isNew": true,
      });
    } catch (e) {
      yield LoginState.failure(isGuest: false);
    }
  }

  Stream<LoginState> _mapLoginPurge() async* {
    yield LoginState.empty();
  }

  @override
  LoginState fromJson(Map<String, dynamic> json) {
    return null;
  }

  @override
  Map<String, dynamic> toJson(LoginState state) {
    return null;
  }
}
