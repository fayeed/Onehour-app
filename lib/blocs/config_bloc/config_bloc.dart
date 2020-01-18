import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import './bloc.dart';

class ConfigBloc extends HydratedBloc<ConfigEvent, ConfigState> {
  @override
  ConfigState get initialState => super.initialState ?? ConfigState.dark();

  @override
  Stream<ConfigState> mapEventToState(
    ConfigEvent event,
  ) async* {
    if (event is LightThemeEvent) {
      yield ConfigState.light();
    } else if (event is DarkThemeEvent) {
      yield ConfigState.dark();
    }
  }

  @override
  ConfigState fromJson(Map<String, dynamic> json) {
    if (json['isDarkModeOn'] as bool) {
      return ConfigState.dark();
    } else {
      return ConfigState.light();
    }
  }

  @override
  Map<String, dynamic> toJson(ConfigState state) {
    return {'isDarkModeOn': state.isDarkModeOn};
  }
}
