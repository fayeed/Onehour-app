import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConfigEvent extends Equatable {
  ConfigEvent([List props = const <dynamic>[]]) : super(props);
}

class LightThemeEvent extends ConfigEvent {
  @override
  String toString() => "LightThemeEvent";
}

class DarkThemeEvent extends ConfigEvent {
  @override
  String toString() => "DarkThemeEvent";
}
