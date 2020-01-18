import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:onehour/pages/config_screen.dart';
import 'package:onehour/repositories/user_repository.dart';
import 'package:onehour/utils/onehour.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  OneHour.prefs = await SharedPreferences.getInstance();

  OneHour.checkDebug();

  BlocSupervisor.delegate = await HydratedBlocDelegate.build();

  final UserRepository userRepository = UserRepository();

  runApp(ConfigScreen(
    userRepository: userRepository,
  ));
}
