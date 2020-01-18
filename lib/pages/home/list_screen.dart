import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onehour/pages/home/bloc/bloc.dart';
import 'package:onehour/widgets/TimerItem.dart';

class ListScreen extends StatefulWidget {
  final PageController pageController;

  ListScreen({this.pageController});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Container(
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 50.0, top: 30.0),
          itemCount: state.trackingList.length,
          itemBuilder: (context, i) => TimerItem(
            onTap: () {
              BlocProvider.of<HomeBloc>(context)
                  .dispatch(EditTimerEvent(pos: i));

              widget.pageController.animateToPage(
                0,
                duration: Duration(milliseconds: 150),
                curve: Curves.bounceIn,
              );
            },
            tracking: state.trackingList[i],
            itemNo: i,
            running: state.active == i,
          ),
        ),
      ),
    );
  }
}
