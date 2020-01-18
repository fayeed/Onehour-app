import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onehour/blocs/authentication_bloc/bloc.dart';
import 'package:onehour/blocs/config_bloc/bloc.dart';
import 'package:onehour/pages/home/bloc/bloc.dart';
import 'package:onehour/utils/onehour.dart';
import 'package:onehour/utils/ui_utils.dart';
import 'package:onehour/widgets/SettingsButton.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  final RateMyApp rateMyApp;
  final FirebaseAnalytics analytics;

  SettingScreen({this.rateMyApp, this.analytics});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final darkTheme =
        BlocProvider.of<ConfigBloc>(context).currentState.isDarkModeOn;
    final analytics = widget.analytics;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: ListView(
            children: <Widget>[
              // * Global Reminders Button
              SettingsButton(
                text: "Global Reminder",
                trailing: Switch.adaptive(
                  value: state.showNotification ?? true,
                  activeColor: OneHour.primarySwatch,
                  inactiveThumbColor:
                      darkTheme ? OneHour.textColor : Colors.black87,
                  onChanged: (value) {
                    BlocProvider.of<HomeBloc>(context).dispatch(
                      ToggleTimerNotificationEvent(
                        showNotification: value,
                      ),
                    );
                  },
                ),
              ),
              // * DarkMode Button
              SettingsButton(
                text: "Dark Mode",
                trailing: Switch.adaptive(
                  value: darkTheme,
                  activeColor: OneHour.primarySwatch,
                  inactiveThumbColor:
                      darkTheme ? OneHour.textColor : Colors.black87,
                  onChanged: (value) {
                    BlocProvider.of<ConfigBloc>(context)
                        .dispatch(value ? DarkThemeEvent() : LightThemeEvent());

                    analytics.logEvent(name: "theme_changed", parameters: {
                      "theme": darkTheme ? "dark" : "light",
                    });
                  },
                ),
              ),
              // * Logout Button
              SettingsButton(
                text: "Logout",
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .dispatch(LoggedOut());

                  BlocProvider.of<HomeBloc>(context)
                      .dispatch(PurgeHomeStateEvent());

                  analytics.logEvent(name: "logged_our");
                },
              ),
              // * Send Feedback Button
              SettingsButton(
                text: "Send Feedback",
                onTap: () async {
                  final url =
                      "mailto:fayeed52@gmail.com?subject=OneHour feedback";

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print("Could not launch $url");
                  }

                  analytics.logEvent(name: "send_feedback");
                },
              ),
              // * Share the app Button
              SettingsButton(
                text: "Share the app",
                onTap: () async {
                  // TODO : Change the url with your app store URL
                  final url = "https://www.google.com";

                  Share.share("check out my website $url");

                  analytics.logEvent(name: "app_share");
                },
              ),
              // * Rate the app Button
              SettingsButton(
                text: "Rate the app",
                onTap: () async {
                  rateApp(context: context, rateMyApp: widget.rateMyApp);

                  analytics.logEvent(name: "rate_app");
                },
              ),
              // * Terms & condition Button
              SettingsButton(
                text: "Terms & Condition",
                onTap: () async {
                  final url =
                      "https://onehours.web.app/terms_and_condition.html";

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print("Could not launch $url");
                  }

                  analytics.logEvent(name: "terms_and_conditions_opened");
                },
              ),
              // * Privacy policy Button
              SettingsButton(
                text: "Privacy policy",
                onTap: () async {
                  final url = "https://onehours.web.app/privacy_policy.html";

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print("Could not launch $url");
                  }

                  analytics.logEvent(name: "privacy_policy_opened");
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
