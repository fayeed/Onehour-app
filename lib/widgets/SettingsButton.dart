import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onehour/blocs/config_bloc/config_bloc.dart';
import 'package:onehour/utils/onehour.dart';

class SettingsButton extends StatelessWidget {
  final String text;
  final Widget trailing;
  final Function onTap;

  SettingsButton({
    this.text,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final darkTheme =
        BlocProvider.of<ConfigBloc>(context).currentState.isDarkModeOn;

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            text,
            style: TextStyle(
              color: darkTheme ? OneHour.textColor : Colors.black87,
              fontSize: 24.0,
            ),
          ),
          trailing: trailing != null
              ? trailing
              : Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    FontAwesomeIcons.chevronRight,
                    color: darkTheme ? OneHour.textColor : Colors.black87,
                  ),
                ),
          onTap: onTap,
        ),
        Divider(
          color: darkTheme ? OneHour.textColor : Colors.black87,
          indent: 15.0,
          endIndent: 15.0,
        ),
      ],
    );
  }
}
