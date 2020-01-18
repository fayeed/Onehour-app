import 'package:meta/meta.dart';
import 'package:onehour/models/tracking.dart';

class HomeState {
  final List<Tracking> trackingList;
  final int active;
  final bool isNew;
  final int edit;
  final bool showNotification;

  HomeState({
    @required this.trackingList,
    @required this.active,
    @required this.isNew,
    @required this.edit,
    @required this.showNotification,
  });

  factory HomeState.empty() {
    return HomeState(
      trackingList: List<Tracking>(),
      active: -1,
      isNew: true,
      edit: -1,
      showNotification: true,
    );
  }

  factory HomeState.updateTime({
    List<Tracking> tracking,
    int active,
    bool isNew = true,
    int edit = -1,
    bool showNotification,
  }) {
    return HomeState(
      trackingList: tracking,
      active: active,
      isNew: isNew,
      edit: edit,
      showNotification: showNotification,
    );
  }
}
