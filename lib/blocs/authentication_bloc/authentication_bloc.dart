import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:onehour/models/user.dart';
import 'package:onehour/repositories/user_repository.dart';
import './bloc.dart';

class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => super.initialState ?? Unintialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState(
        isGuest: event.isGuest,
        isNew: event.isNew,
        user: event.user,
        data: event.data,
      );
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final result = await _userRepository.getUser();
        final error = result["error"];

        if (error == null) {
          final user = result["user"];
          final User data = result["data"];

          yield Authenticated(user: user, data: data, autoLogin: true);
        } else {
          yield Unauthenticated();
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState({
    bool isGuest,
    isNew,
    FirebaseUser user,
    User data,
  }) async* {
    yield Authenticated(
      user: user,
      data: data,
      isGuest: isGuest,
      isNew: isNew,
    );
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }

  @override
  AuthenticationState fromJson(Map<String, dynamic> json) {
    try {
      return Authenticated(autoLogin: true);
    } catch (e) {
      return Unauthenticated();
    }
  }

  @override
  Map<String, dynamic> toJson(AuthenticationState state) {
    return null;
  }
}
