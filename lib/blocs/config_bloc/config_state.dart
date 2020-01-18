class ConfigState {
  bool isDarkModeOn;

  ConfigState({this.isDarkModeOn});

  factory ConfigState.light() {
    return ConfigState(isDarkModeOn: false);
  }

  factory ConfigState.dark() {
    return ConfigState(isDarkModeOn: true);
  }

  @override
  String toString() => "ConfigThemeState";
}
