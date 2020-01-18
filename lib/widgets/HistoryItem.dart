import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onehour/blocs/config_bloc/config_bloc.dart';
import 'package:onehour/models/history.dart';
import 'package:onehour/utils/onehour.dart';

class HistoryItem extends StatelessWidget {
  HistoryItem({this.item});

  final History item;

  @override
  Widget build(BuildContext context) {
    final darkTheme =
        BlocProvider.of<ConfigBloc>(context).currentState.isDarkModeOn;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 28.0,
                  ),
                ),
              ),
              Text(
                item.currentTime.toString().split(".")[0],
                style: TextStyle(fontSize: 28.0),
              ),
            ],
          ),
          Divider(
            color: darkTheme ? OneHour.textColor : Colors.black87,
          )
        ],
      ),
    );
  }
}
