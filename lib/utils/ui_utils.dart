import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'onehour.dart';

void rateApp({
  BuildContext context,
  RateMyApp rateMyApp,
}) {
  if (Platform.isAndroid) {
    rateMyApp.showRateDialog(
      context,
      title: "Rate this app",
    );
  } else {
    rateMyApp.showStarRateDialog(
      context,
      title: "Rate this app",
      message:
          "You like this app? Then take a little bit of your time to leave a rating :",
      onRatingChanged: (stars) {
        return [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              rateMyApp.doNotOpenAgain = true;
              rateMyApp.save().then((v) => Navigator.pop(context));
            },
          ),
        ];
      },
      starRatingOptions: StarRatingOptions(),
    );
  }
}

void showFlushBar({
  BuildContext context,
  String title,
  String message,
  Duration duration,
}) {
  Flushbar(
    titleText: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 24.0,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
    ),
    duration: duration ?? Duration(seconds: 3),
    flushbarStyle: FlushbarStyle.GROUNDED,
    flushbarPosition: FlushbarPosition.TOP,
    forwardAnimationCurve: Curves.decelerate,
    reverseAnimationCurve: Curves.easeOut,
    backgroundColor: OneHour.primarySwatch,
  )..show(context);
}
