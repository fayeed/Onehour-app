import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onehour/blocs/config_bloc/config_bloc.dart';
import 'package:onehour/models/history.dart';
import 'package:onehour/pages/home/bloc/home_bloc.dart';
import 'package:onehour/pages/home/bloc/home_state.dart';
import 'package:onehour/utils/onehour.dart';
import 'package:onehour/widgets/HistoryItem.dart';

enum FilterType { WEEK, MONTH, YEAR }

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  FilterType filter = FilterType.WEEK;

  List<History> _getFilterItem(HomeState state, FilterType filter) {
    final today = DateTime.now();

    final finalList = List<History>();

    int threshold = 7;

    if (filter == FilterType.WEEK) {
      threshold = 7;
    } else if (filter == FilterType.MONTH) {
      threshold = 30;
    } else if (filter == FilterType.YEAR) {
      threshold = 365;
    }

    for (var l in state.trackingList) {
      final times = l.history
          .where((x) =>
              today.difference(x["startBlock"]).inDays <= threshold &&
              today.difference(x["endBlock"]).inDays <= threshold)
          .toList();

      var hours = 0;
      var minutes = 0;
      var seconds = 0;

      for (var time in times) {
        final t = time["endBlock"].difference(time["startBlock"]);
        hours += t.inHours;
        minutes += t.inMinutes;
        seconds += t.inSeconds;
      }

      final _date = Duration(hours: hours, minutes: minutes, seconds: seconds);

      finalList.add(History(title: l.title, currentTime: _date));
    }

    return finalList;
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme =
        BlocProvider.of<ConfigBloc>(context).currentState.isDarkModeOn;

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      final finalList = _getFilterItem(state, filter);

      return Container(
        margin:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButton(
              style: TextStyle(
                color: OneHour.primarySwatch,
                fontSize: 32.0,
                fontWeight: FontWeight.w700,
              ),
              elevation: 0,
              underline: Container(),
              value: filter,
              icon: Icon(
                FontAwesomeIcons.chevronDown,
                color: OneHour.primarySwatch,
              ),
              items: [
                DropdownMenuItem(
                  child: Text("WEEK"),
                  value: FilterType.WEEK,
                ),
                DropdownMenuItem(
                  child: Text("MONTH"),
                  value: FilterType.MONTH,
                ),
                DropdownMenuItem(
                  child: Text("YEAR"),
                  value: FilterType.YEAR,
                )
              ],
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: darkTheme ? OneHour.textColor : Colors.black87,
              height: 5.0,
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: finalList.length,
                itemBuilder: (context, i) {
                  return HistoryItem(
                    item: finalList[i],
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
