import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:onehour/blocs/config_bloc/config_bloc.dart';
import 'package:onehour/models/tracking.dart';
import 'package:onehour/pages/home/bloc/bloc.dart';
import 'package:onehour/pages/home/bloc/home_bloc.dart';
import 'package:onehour/pages/home/setting_screen.dart';
import 'package:onehour/utils/onehour.dart';

class AddScreen extends StatefulWidget {
  final PageController pageController;

  AddScreen({this.pageController});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _timeLimitController = TextEditingController();
  OverlayEntry overlayEntry;
  String _titleError;
  String _timeLimitError;
  BuildContext _newContext;
  FocusNode focusNode = FocusNode();
  bool toggleReminderValue = true;

  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onShow: () {
        showOverlay(context);
      },
      onHide: () {
        removeOverlay();
      },
    );

    super.initState();
  }

  void showOverlay(BuildContext context) {
    if (overlayEntry != null) return;

    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      final isNew = BlocProvider.of<HomeBloc>(_newContext).currentState.isNew;

      if (isNew) {
        return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: OneHour.primarySwatch,
                      fontSize: 24.0,
                    ),
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    widget.pageController.jumpToPage(1);

                    BlocProvider.of<HomeBloc>(_newContext)
                        .dispatch(IsNewTimerEvent());
                  },
                ),
                FlatButton(
                  child: Text(
                    "Start",
                    style: TextStyle(
                      color: OneHour.primarySwatch,
                      fontSize: 24.0,
                    ),
                  ),
                  onPressed: () {
                    if (_titleController.value.text.length > 5) {
                      setState(() {
                        _titleError = null;
                      });

                      FocusScope.of(context).requestFocus(FocusNode());

                      BlocProvider.of<HomeBloc>(_newContext).dispatch(
                        AddTimerEvent(
                          title: _titleController.value.text,
                          description: "",
                        ),
                      );
                    } else {
                      setState(() {
                        _titleError =
                            "Title cannot be empty or less then 5 characters";
                      });
                    }
                  },
                )
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });

    overlayState.insert(overlayEntry);
  }

  void removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _newContext = context;
    final darkTheme =
        BlocProvider.of<ConfigBloc>(context).currentState.isDarkModeOn;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final isNew = state.isNew;
        final active = state.active;
        var tracking = isNew && state.edit == -1
            ? Tracking()
            : state.edit == -1 ? Tracking() : state.trackingList[state.edit];

        if (!isNew) {
          _titleController.text = tracking.title;
          _descriptionController.text = tracking.description;
        } else if (isNew && _titleController.value.text.length == 0) {
          _titleController.text = "";
          _descriptionController.text = "";
          tracking = Tracking();
          FocusScope.of(context).requestFocus(focusNode);
        }

        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  focusNode: focusNode,
                  autofocus: isNew,
                  controller: _titleController,
                  onEditingComplete: () {
                    if (!isNew) {
                      if (isNew == false && state.edit == -1) {
                        setState(() {
                          _titleError = null;
                        });

                        FocusScope.of(context).requestFocus(FocusNode());
                      } else {
                        BlocProvider.of<HomeBloc>(context).dispatch(
                            UpdateTimerEvent(
                                title: _titleController.value.text));

                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    }
                  },
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 3,
                  style: TextStyle(
                    color: darkTheme ? OneHour.textColor : Colors.black87,
                    fontSize: 48.0,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: "What you wanna do?",
                    hintMaxLines: 3,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: darkTheme
                          ? OneHour.textColor.withAlpha(90)
                          : Colors.black87.withAlpha(90),
                      fontSize: 48.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _titleError != null
                    ? Text(
                        _titleError,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      )
                    : Container(),
                !isNew
                    ? Column(
                        children: <Widget>[
                          Divider(
                            height: 5.0,
                            color:
                                darkTheme ? OneHour.textColor : Colors.black87,
                          ),
                          // * Description TextField
                          Container(
                            child: TextField(
                              controller: _descriptionController,
                              maxLines: 3,
                              minLines: 1,
                              onEditingComplete: () {
                                BlocProvider.of<HomeBloc>(context).dispatch(
                                    UpdateTimerEvent(
                                        description:
                                            _descriptionController.value.text));

                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: darkTheme
                                    ? OneHour.textColor
                                    : Colors.black87,
                                fontSize: 28.0,
                              ),
                              decoration: InputDecoration(
                                hintText: "Description or link",
                                hintMaxLines: 3,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: darkTheme
                                      ? OneHour.textColor.withAlpha(90)
                                      : Colors.black87.withAlpha(90),
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 5.0,
                            color:
                                darkTheme ? OneHour.textColor : Colors.black87,
                          ),
                          // * Time interact Button
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child: Icon(
                                    !tracking.active
                                        ? FontAwesomeIcons.play
                                        : FontAwesomeIcons.pause,
                                    color: tracking.active
                                        ? OneHour.primarySwatch
                                        : darkTheme
                                            ? OneHour.textColor
                                            : Colors.black87,
                                    size: 48.0,
                                  ),
                                  onTap: () {
                                    BlocProvider.of<HomeBloc>(context).dispatch(
                                      !tracking.active
                                          ? StartTimerEvent(pos: state.edit)
                                          : StopTimerEvent(),
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
                                Text(
                                  tracking.currentTime.toString().split(".")[0],
                                  style: TextStyle(
                                    fontSize: 48.0,
                                    color: tracking.active
                                        ? OneHour.primarySwatch
                                        : darkTheme
                                            ? OneHour.textColor
                                            : Colors.black87,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 5.0,
                            color:
                                darkTheme ? OneHour.textColor : Colors.black87,
                          ),
                          // * Reminder Toggle Button
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Reminder",
                                  style: TextStyle(fontSize: 28.0),
                                ),
                                Switch.adaptive(
                                  value: isNew
                                      ? toggleReminderValue
                                      : tracking.showReminder,
                                  onChanged: (val) {
                                    if (isNew) {
                                      setState(() {
                                        toggleReminderValue = val;
                                      });
                                    }

                                    BlocProvider.of<HomeBloc>(context).dispatch(
                                      UpdateTimerEvent(showReminder: val),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 5.0,
                            color:
                                darkTheme ? OneHour.textColor : Colors.black87,
                          ),
                          // * Reminder  Button
                          DateTimeField(
                            enabled: isNew
                                ? toggleReminderValue
                                : tracking.showReminder,
                            format: DateFormat("HH:mm:ss"),
                            initialValue: tracking.reminderTime,
                            onShowPicker:
                                (context, DateTime currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now(),
                                ),
                              );

                              final newTime = DateTimeField.convert(time);

                              BlocProvider.of<HomeBloc>(context).dispatch(
                                UpdateTimerEvent(reminderTime: newTime),
                              );

                              return newTime;
                            },
                            onFieldSubmitted: (time) {
                              if (time == null) {
                                // TODO : error here...
                              } else {
                                BlocProvider.of<HomeBloc>(context).dispatch(
                                  UpdateTimerEvent(reminderTime: time),
                                );
                              }
                            },
                            style: TextStyle(
                              color: OneHour.textColor,
                              fontSize: 28.0,
                            ),
                            decoration: InputDecoration(
                              hintText: "hh:mm:ss",
                              hintMaxLines: 3,
                              border: InputBorder.none,
                              labelText: "Reminder time",
                              labelStyle: TextStyle(
                                color: OneHour.textColor,
                                fontSize: 18.0,
                              ),
                              hintStyle: TextStyle(
                                color: darkTheme
                                    ? OneHour.textColor.withAlpha(90)
                                    : Colors.black87.withAlpha(90),
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                          Divider(
                            height: 5.0,
                            color:
                                darkTheme ? OneHour.textColor : Colors.black87,
                          ),
                          // * Time Limit Button
                          DateTimeField(
                            format: DateFormat("HH:mm:ss"),
                            initialValue: tracking.timeLimit,
                            onShowPicker:
                                (context, DateTime currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ??
                                        DateTime.utc(2019, 1, 1, 1)),
                              );

                              final newTime = DateTimeField.convert(time);

                              BlocProvider.of<HomeBloc>(context).dispatch(
                                UpdateTimerEvent(timeLimit: newTime),
                              );

                              return newTime;
                            },
                            onFieldSubmitted: (time) {
                              if (time == null) {
                                // TODO : show error here...
                              } else {
                                BlocProvider.of<HomeBloc>(context).dispatch(
                                  UpdateTimerEvent(timeLimit: time),
                                );
                              }
                            },
                            style: TextStyle(
                              color: OneHour.textColor,
                              fontSize: 28.0,
                            ),
                            decoration: InputDecoration(
                              hintText: "hh:mm:ss",
                              hintMaxLines: 3,
                              border: InputBorder.none,
                              labelText: "Time limit",
                              labelStyle: TextStyle(
                                color: OneHour.textColor,
                                fontSize: 18.0,
                              ),
                              hintStyle: TextStyle(
                                color: darkTheme
                                    ? OneHour.textColor.withAlpha(90)
                                    : Colors.black87.withAlpha(90),
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                          Divider(
                            height: 5.0,
                            color:
                                darkTheme ? OneHour.textColor : Colors.black87,
                          ),
                          // * History Button
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "History",
                                  style: TextStyle(fontSize: 24.0),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    widget.pageController.animateToPage(
                                      3,
                                      duration: Duration(milliseconds: 150),
                                      curve: Curves.bounceIn,
                                    );
                                  },
                                  child: Text(
                                    "${tracking.history.length} items >",
                                    style: TextStyle(fontSize: 24.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 5.0,
                            color:
                                darkTheme ? OneHour.textColor : Colors.black87,
                          ),
                          // * Stop Button
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                widget.pageController.animateToPage(
                                  1,
                                  duration: Duration(milliseconds: 150),
                                  curve: Curves.bounceIn,
                                );

                                if (active != -1) {
                                  BlocProvider.of<HomeBloc>(context).dispatch(
                                      UpdateTimerEvent(
                                          description:
                                              _descriptionController.value.text,
                                          title: _titleController.value.text));

                                  BlocProvider.of<HomeBloc>(context)
                                      .dispatch(StopTimerEvent());
                                }
                              },
                              child: Text(
                                "Stop and finish",
                                style: TextStyle(
                                    fontSize: 24.0,
                                    color: OneHour.primarySwatch),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
