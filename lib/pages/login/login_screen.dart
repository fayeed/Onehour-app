import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onehour/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:onehour/blocs/authentication_bloc/authentication_event.dart';
import 'package:onehour/pages/login/bloc/bloc.dart';
import 'package:onehour/pages/login/email_login_screen.dart';
import 'package:onehour/repositories/user_repository.dart';
import 'package:onehour/utils/email_screen_argument.dart';
import 'package:onehour/utils/onehour.dart';
import 'package:onehour/widgets/loginButton.dart';
import 'package:onehour/widgets/socialIcon.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";

  final UserRepository userRepository;
  final FirebaseAnalytics analytics;

  LoginScreen({
    this.userRepository,
    this.analytics,
  });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      builder: (context) => LoginBloc(
        userRepository: widget.userRepository,
        analytics: widget.analytics,
      ),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) {
          if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn(
              isGuest: state.isGuest,
              isNew: state.isNew,
              user: state.user,
              data: state.data,
            ));
          } else if (state.isFailure) {
            _scaffoldKey.currentState
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Login Failure'),
                      Icon(FontAwesomeIcons.exclamationTriangle)
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          } else if (state.isLoading) {
            _scaffoldKey.currentState
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: OneHour.primarySwatch,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Loading',
                        style: TextStyle(color: Colors.black, fontSize: 24.0),
                      ),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (BuildContext context, LoginState state) {
            final width = MediaQuery.of(context).size.width;
            final height = MediaQuery.of(context).size.height;

            return Scaffold(
              key: _scaffoldKey,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: width * 0.6,
                    margin: EdgeInsets.only(
                      top: height * 0.05,
                    ),
                    child: Text(
                      "1H",
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontSize: width * 0.6,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Container(
                    height: height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        LoginButton(
                          text: "Login as guests",
                          icon: FontAwesomeIcons.user,
                          width: width * 0.7,
                          onTap: !state.isLoading
                              ? () {
                                  BlocProvider.of<LoginBloc>(context)
                                      .dispatch(LoginAsGuest());
                                }
                              : null,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.08,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SocialIcons(
                                icon: FontAwesomeIcons.google,
                                onTap: !state.isLoading
                                    ? () {
                                        BlocProvider.of<LoginBloc>(context)
                                            .dispatch(LoginAsGoogle());
                                      }
                                    : null,
                              ),
                              SocialIcons(
                                icon: FontAwesomeIcons.facebook,
                                onTap: !state.isLoading
                                    ? () {
                                        BlocProvider.of<LoginBloc>(context)
                                            .dispatch(LoginAsFacebook());
                                      }
                                    : null,
                              ),
                              SocialIcons(
                                icon: FontAwesomeIcons.envelope,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    EmailLoginScreen.routeName,
                                    arguments: EmailScreenArgument(
                                      userRepository: widget.userRepository,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      // call url_launcher here leads to T&C page
                    },
                    child: Text(
                      "Terms and Conditions",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
