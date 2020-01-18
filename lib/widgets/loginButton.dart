import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onehour/blocs/config_bloc/config_bloc.dart';
import 'package:onehour/utils/onehour.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    @required this.width,
    @required this.onTap,
    @required this.icon,
    @required this.text,
  }) : super(key: key);

  final double width;
  final Function onTap;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final darkTheme =
        BlocProvider.of<ConfigBloc>(context).currentState.isDarkModeOn;
    return FlatButton(
      onPressed: onTap,
      child: Container(
        color: OneHour.primarySwatch,
        height: 56.0,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: darkTheme ? Colors.black : Colors.white,
            ),
            SizedBox(
              width: 15.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 24.0,
                  color: darkTheme ? Colors.black : Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
