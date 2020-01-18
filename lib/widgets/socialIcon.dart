import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onehour/blocs/config_bloc/config_bloc.dart';
import 'package:onehour/utils/onehour.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({
    Key key,
    this.onTap,
    this.icon,
  }) : super(key: key);

  final Function onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final darkTheme =
        BlocProvider.of<ConfigBloc>(context).currentState.isDarkModeOn;
    return GestureDetector(
      child: Container(
        height: 56.0,
        width: 56.0,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: darkTheme ? OneHour.textColor : Colors.black87,
          ),
        ),
        child: Icon(
          icon,
          color: darkTheme ? OneHour.textColor : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
