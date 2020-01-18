import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onehour/blocs/config_bloc/config_bloc.dart';
import 'package:onehour/models/tracking.dart';
import 'package:onehour/pages/home/add_screen.dart';
import 'package:onehour/pages/home/bloc/bloc.dart';
import 'package:onehour/pages/home/history_screen.dart';
import 'package:onehour/pages/home/list_screen.dart';
import 'package:onehour/pages/home/setting_screen.dart';
import 'package:onehour/repositories/config_repository.dart';
import 'package:onehour/repositories/user_repository.dart';
import 'package:onehour/utils/login_screen_argument.dart';
import 'package:onehour/utils/onehour.dart';
import 'package:onehour/utils/ui_utils.dart';
import 'package:onehour/widgets/BottomTabIcon.dart';
import 'package:rate_my_app/rate_my_app.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  final LoginScreenArgument loginOptions;
  final UserRepository userRepository;
  final List<Tracking> trackingList;
  final FirebaseAnalytics analytics;

  HomeScreen({
    this.loginOptions,
    this.userRepository,
    this.trackingList,
    this.analytics,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );
  AppLifecycleState _notification;
  double currentPage = 1.0;
  bool firstScreenShown = false;
  bool shown = false;
  RateMyApp rateMyApp;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<dynamic> onDidReceiveLocalNotification(
      int code, String val1, val2, val3) async {
    // TODO: code here...
    print("onDidReceiveLocalNotification");
  }

  Future<dynamic> onSelectNotification(String val) async {
    // TODO: code here...
    print("onSelectNotification");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2158682632364662~7675269294';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2158682632364662~8464274227';
    }
    return null;
  }

  String getInterestailAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2158682632364662/2446175108';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2158682632364662/5234092767';
    }
    return null;
  }

  @override
  void initState() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final initializationSettingsAndroid = AndroidInitializationSettings('icon');

    final initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page;
      });
    });

    Config().setupRemoteConfig().then((val) {
      final shouldShowAds = val.getBool("show_ads");

      if (shouldShowAds && !widget.loginOptions.isNew) {
        FirebaseAdMob.instance.initialize(appId: getBannerAdUnitId());

        InterstitialAd(
          // TODO : replace testUnitId with the real ID
          // * ca-app-pub-2158682632364662/5234092767 - Android
          // * ca-app-pub-2158682632364662/2446175108 - IOS
          adUnitId: getInterestailAdUnitId(),
          listener: (MobileAdEvent event) {
            print("InterstitialAd event is $event");
          },
        )
          ..load()
          ..show();
      }
    });

    rateMyApp = RateMyApp(
      minDays: 7,
      minLaunches: 10,
      remindDays: 7,
      remindLaunches: 10,
    );

    rateMyApp.init().then((val) {
      if (rateMyApp.shouldOpenDialog) {
        Timer(Duration(milliseconds: 150), () {
          rateApp(context: context, rateMyApp: rateMyApp);
        });
      }
    });

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme =
        BlocProvider.of<ConfigBloc>(context).currentState.isDarkModeOn;

    print("${widget.loginOptions} | $shown");
    if (widget.loginOptions != null && widget.loginOptions.isGuest && !shown) {
      setState(() {
        currentPage = widget.loginOptions.isNew ? 0.0 : 1.0;
        shown = true;
      });

      Timer(Duration(milliseconds: 50), () {
        showFlushBar(
          context: context,
          title: "You logged in as a guest",
          message:
              "Whenever you logged in as a guest the data will be store on your device only",
        );
      });
    }

    return BlocProvider<HomeBloc>(
      builder: (context) => HomeBloc(
        userRepository: widget.userRepository,
        data: widget.trackingList,
        analytics: widget.analytics,
        notification: flutterLocalNotificationsPlugin,
      ),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if (state.active != -1) {
            final activeTimer = state.trackingList[state.active];

            final timeLimit = Duration(
              hours: activeTimer.timeLimit.hour,
              minutes: activeTimer.timeLimit.minute,
              seconds: activeTimer.timeLimit.second,
              milliseconds: activeTimer.timeLimit.millisecond,
            );

            if (activeTimer.currentTime.compareTo(timeLimit) == 0) {
              if (_notification == AppLifecycleState.paused) {
                final random = Random();

                final androidPlatformChannelSpecifics =
                    AndroidNotificationDetails(
                  'com.codenimble.onehour',
                  'onehour_channel',
                  'channel used for notification by onehour app.',
                  importance: Importance.Max,
                  priority: Priority.High,
                  ticker: 'ticker',
                );

                final iOSPlatformChannelSpecifics = IOSNotificationDetails();

                final platformChannelSpecifics = NotificationDetails(
                  androidPlatformChannelSpecifics,
                  iOSPlatformChannelSpecifics,
                );

                await flutterLocalNotificationsPlugin.show(
                  random.nextInt(100),
                  'Time Limit Reached',
                  'Hey you have reached you daily time limit for this task, if you more time here other tasks may suffer',
                  platformChannelSpecifics,
                );
              } else if (_notification == AppLifecycleState.resumed) {
                showFlushBar(
                  context: context,
                  title: "Time Limit Reached",
                  message:
                      "Hey you have reached you daily time limit for this task, if you more time here other tasks may suffer",
                  duration: Duration(seconds: 6),
                );
              }
            }
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (widget.loginOptions.isNew && !firstScreenShown) {
              Timer(Duration(milliseconds: 50), () {
                BlocProvider.of<HomeBloc>(context)
                    .dispatch(IsNewTimerEvent(isNew: true));

                pageController.jumpToPage(0);

                setState(() {
                  firstScreenShown = true;
                });
              });
            }

            return Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          AddScreen(pageController: pageController),
                          ListScreen(pageController: pageController),
                          HistoryScreen(),
                          SettingScreen(
                            rateMyApp: rateMyApp,
                            analytics: widget.analytics,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          BottomTabIcon(
                            currentPage: currentPage,
                            pageController: pageController,
                            pageNo: 0.0,
                            icon: FontAwesomeIcons.plus,
                            onTap: () {
                              BlocProvider.of<HomeBloc>(context)
                                  .dispatch(IsNewTimerEvent(isNew: true));
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: currentPage == 1.0
                                    ? OneHour.primarySwatch
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(2.5),
                                border: Border.all(
                                  color: currentPage == 1.0
                                      ? OneHour.primarySwatch
                                      : Theme.of(context).iconTheme.color,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  state.trackingList.length.toString(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: currentPage == 1.0
                                        ? darkTheme
                                            ? Colors.black
                                            : Colors.white
                                        : darkTheme
                                            ? OneHour.textColor
                                            : Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              pageController.animateToPage(
                                1,
                                duration: Duration(milliseconds: 150),
                                curve: Curves.bounceIn,
                              );
                            },
                          ),
                          BottomTabIcon(
                            icon: FontAwesomeIcons.chartBar,
                            pageController: pageController,
                            pageNo: 2.0,
                            currentPage: currentPage,
                            onTap: () {},
                          ),
                          BottomTabIcon(
                            icon: FontAwesomeIcons.cog,
                            onTap: () {},
                            pageNo: 3.0,
                            pageController: pageController,
                            currentPage: currentPage,
                          )
                        ],
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
