import 'package:flutter/material.dart';
import 'package:onehour/utils/onehour.dart';

class BottomTabIcon extends StatelessWidget {
  const BottomTabIcon({
    Key key,
    @required this.currentPage,
    @required this.pageController,
    @required this.icon,
    @required this.pageNo,
    @required this.onTap,
  }) : super(key: key);

  final double currentPage;
  final PageController pageController;
  final IconData icon;
  final double pageNo;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        icon,
        size: 40,
        color: currentPage == pageNo
            ? OneHour.primarySwatch
            : Theme.of(context).iconTheme.color,
      ),
      onTap: () {
        onTap();

        pageController.animateToPage(
          pageNo.toInt(),
          duration: Duration(milliseconds: 150),
          curve: Curves.bounceIn,
        );
      },
    );
  }
}
