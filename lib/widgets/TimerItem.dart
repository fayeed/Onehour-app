import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onehour/blocs/config_bloc/config_bloc.dart';
import 'package:onehour/models/tracking.dart';
import 'package:onehour/pages/home/bloc/bloc.dart';
import 'package:onehour/pages/home/bloc/home_bloc.dart';
import 'package:onehour/utils/onehour.dart';

class TimerItem extends StatelessWidget {
  TimerItem({
    this.tracking,
    this.itemNo,
    this.running,
    this.onTap,
  });

  final Tracking tracking;
  final int itemNo;
  final bool running;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final darkTheme =
        BlocProvider.of<ConfigBloc>(context).currentState.isDarkModeOn;

    return Dismissible(
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Deleted",
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              FontAwesomeIcons.trash,
              size: 36.0,
            )
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      key: Key(tracking.title),
      onDismissed: (direction) {
        BlocProvider.of<HomeBloc>(context).dispatch(
          DeleteTimerEvent(
            itemNo: itemNo,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: darkTheme ? Colors.black : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          running
                              ? FontAwesomeIcons.pause
                              : FontAwesomeIcons.play,
                          size: 56.0,
                          color: running
                              ? OneHour.primarySwatch
                              : darkTheme ? OneHour.textColor : Colors.black87,
                        ),
                        onTap: () {
                          if (running) {
                            BlocProvider.of<HomeBloc>(context)
                                .dispatch(StopTimerEvent());
                          } else {
                            BlocProvider.of<HomeBloc>(context)
                                .dispatch(StartTimerEvent(pos: itemNo));
                          }
                        },
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        tracking.currentTime.toString().split(".")[0] ?? "",
                        style: TextStyle(
                          color: running
                              ? OneHour.primarySwatch
                              : darkTheme ? OneHour.textColor : Colors.black87,
                          fontSize: 64.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  running
                      ? Icon(
                          FontAwesomeIcons.clock,
                          color: OneHour.primarySwatch,
                        )
                      : Container()
                ],
              ),
              Text(
                tracking.title ?? "",
                style: TextStyle(
                  color: running
                      ? OneHour.primarySwatch
                      : darkTheme ? OneHour.textColor : Colors.black87,
                  fontSize: 28.0,
                ),
              ),
              Divider(
                color: darkTheme ? OneHour.textColor : Colors.black87,
              )
            ],
          ),
        ),
      ),
    );
  }
}
