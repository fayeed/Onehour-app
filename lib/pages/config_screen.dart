import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onehour/blocs/authentication_bloc/bloc.dart';
import 'package:onehour/blocs/config_bloc/bloc.dart';
import 'package:onehour/pages/home/home_screen.dart';
import 'package:onehour/pages/login/bloc/login_bloc.dart';
import 'package:onehour/pages/login/email_login_screen.dart';
import 'package:onehour/pages/login/login_screen.dart';
import 'package:onehour/pages/splash_screen.dart';
import 'package:onehour/repositories/user_repository.dart';
import 'package:onehour/utils/login_screen_argument.dart';
import 'package:onehour/utils/onehour.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ConfigScreen extends StatefulWidget {
  static const String routeName = "/";

  final UserRepository userRepository;

  ConfigScreen({this.userRepository});

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ConfigBloc>(
          builder: (BuildContext context) => ConfigBloc(),
        ),
        BlocProvider<AuthenticationBloc>(
          builder: (BuildContext context) => AuthenticationBloc(
            userRepository: widget.userRepository,
          )..dispatch(AppStarted()),
        ),
        BlocProvider<LoginBloc>(
          builder: (BuildContext context) => LoginBloc(),
        )
      ],
      child: BlocBuilder<ConfigBloc, ConfigState>(
        builder: (context, state) {
          return MaterialApp(
            title: OneHour.app_name,
            debugShowCheckedModeBanner: OneHour.isDebugMode,
            theme: ThemeData(
              scaffoldBackgroundColor:
                  state.isDarkModeOn ? Colors.black : Colors.white,
              fontFamily: OneHour.myriad_pro_family,
              primarySwatch: Colors.pink,
              primaryColor: state.isDarkModeOn
                  ? OneHour.primaryColor
                  : OneHour.secondaryColor,
              disabledColor: Colors.grey,
              brightness:
                  state.isDarkModeOn ? Brightness.dark : Brightness.light,
              buttonTheme: Theme.of(context).buttonTheme.copyWith(
                    colorScheme: state.isDarkModeOn
                        ? ColorScheme.dark()
                        : ColorScheme.light(),
                  ),
              textTheme: TextTheme(
                title: TextStyle(
                  color:
                      state.isDarkModeOn ? OneHour.textColor : Colors.black87,
                ),
                button: TextStyle(
                  color:
                      state.isDarkModeOn ? OneHour.textColor : Colors.black87,
                ),
                body1: TextStyle(
                  color:
                      state.isDarkModeOn ? OneHour.textColor : Colors.black87,
                ),
                headline: TextStyle(
                  color:
                      state.isDarkModeOn ? OneHour.textColor : Colors.black87,
                ),
              ),
              appBarTheme: AppBarTheme(
                elevation: 0.0,
              ),
              iconTheme: IconThemeData(
                color: state.isDarkModeOn ? OneHour.textColor : Colors.black87,
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        state.isDarkModeOn ? OneHour.textColor : Colors.black87,
                  ),
                ),
              ),
            ),
            home: App(
              userRepository: widget.userRepository,
              analytics: analytics,
            ),
            routes: {
              LoginScreen.routeName: (context) => LoginScreen(),
              SplashScreen.routeName: (context) => SplashScreen(),
              HomeScreen.routeName: (context) => HomeScreen(),
              EmailLoginScreen.routeName: (context) => EmailLoginScreen()
            },
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
          );
        },
      ),
    );
  }
}

class App extends StatelessWidget {
  App({this.userRepository, this.analytics});

  final UserRepository userRepository;
  final FirebaseAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) {
        if (state is Unauthenticated) {
          return LoginScreen(
            userRepository: userRepository,
            analytics: analytics,
          );
        } else if (state is Authenticated) {
          return HomeScreen(
            analytics: analytics,
            userRepository: userRepository,
            trackingList: state.autoLogin ? null : state.data.trackingList,
            loginOptions: LoginScreenArgument(
              routeName: LoginScreen.routeName,
              isGuest: state.isGuest != null ? state.isGuest : false,
              isNew: state.isNew != null ? state.isNew : false,
            ),
          );
        }
        return SplashScreen();
      },
    );
  }
}
