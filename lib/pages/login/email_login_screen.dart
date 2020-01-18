import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onehour/blocs/authentication_bloc/bloc.dart';
import 'package:onehour/blocs/config_bloc/config_bloc.dart';
import 'package:onehour/pages/home/bloc/bloc.dart';
import 'package:onehour/pages/login/bloc/bloc.dart';
import 'package:onehour/repositories/user_repository.dart';
import 'package:onehour/utils/email_screen_argument.dart';
import 'package:onehour/utils/onehour.dart';
import 'package:onehour/widgets/loginButton.dart';

class EmailLoginScreen extends StatefulWidget {
  static String routeName = "/login/email";

  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    final EmailScreenArgument args = ModalRoute.of(context).settings.arguments;
    final darkTheme =
        BlocProvider.of<ConfigBloc>(context).currentState.isDarkModeOn;

    return BlocProvider(
      builder: (context) => LoginBloc(userRepository: args.userRepository),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.of(context).pop();
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
          builder: (context, state) {
            return Scaffold(
              key: _scaffoldKey,
              body: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 30.0,
                      left: 10.0,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 36.0,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/icon.png",
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextFormField(
                                onFieldSubmitted: (String value) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "jhon@xyz.com",
                                  labelText: 'E-mail Address',
                                  labelStyle: TextStyle(
                                    color: darkTheme
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: darkTheme
                                          ? OneHour.textColor
                                          : Colors.black87,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: darkTheme
                                          ? OneHour.textColor
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  color: darkTheme
                                      ? OneHour.textColor
                                      : Colors.black87,
                                ),
                                validator: (value) {
                                  RegExp emailRegex = RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                                  if (value.isEmpty) {
                                    return "Please enter some text";
                                  } else if (!emailRegex.hasMatch(value)) {
                                    return "Email is in valid";
                                  }

                                  return null;
                                },
                                onSaved: (String value) {
                                  setState(() {
                                    this.email = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextFormField(
                                obscureText: true,
                                focusNode: _passwordFocusNode,
                                onFieldSubmitted: (String value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                decoration: InputDecoration(
                                  hintText: "xyz123@tour",
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: darkTheme
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: darkTheme
                                          ? OneHour.textColor
                                          : Colors.black87,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: darkTheme
                                          ? OneHour.textColor
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  RegExp passwordRegex = RegExp(
                                      r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}");
                                  if (value.isEmpty) {
                                    return "Please enter some text";
                                  } else if (!passwordRegex.hasMatch(value)) {
                                    return "Password is invalid";
                                  }

                                  return null;
                                },
                                onSaved: (String value) {
                                  setState(() {
                                    this.password = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 80.0,
                            ),
                            LoginButton(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  _formKey.currentState.save();

                                  BlocProvider.of<LoginBloc>(context)
                                      .dispatch(LoginAsEmail(
                                    email: this.email,
                                    password: this.password,
                                  ));
                                }
                              },
                              text: "Login",
                              icon: FontAwesomeIcons.user,
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
