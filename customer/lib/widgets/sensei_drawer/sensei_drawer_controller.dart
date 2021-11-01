import 'package:customer/widgets/sensei_drawer/sensei_drawer_state.dart';
import 'package:flutter/material.dart';

/// Controls the Drawer Wrapper class
/// Field [TickerProvider vsync] is required
/// Field [Duration duration] is set to 250ms by default
class SenseiDrawerController extends ChangeNotifier {
  final TickerProvider vsync;
  final Duration duration;
  final AnimationController _animationController;
  SenseiDrawerState state = SenseiDrawerState.closed;

  SenseiDrawerController(
      {@required this.vsync, this.duration = const Duration(milliseconds: 250)})
      : _animationController =
            AnimationController(duration: duration, vsync: vsync) {
    _initController();
  }

  void _initController() {
    _animationController
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = SenseiDrawerState.opening;
            break;
          case AnimationStatus.reverse:
            state = SenseiDrawerState.closing;
            break;
          case AnimationStatus.completed:
            state = SenseiDrawerState.closed;
            break;
          case AnimationStatus.dismissed:
            state = SenseiDrawerState.closed;
            break;
          default:
            state = SenseiDrawerState.closed;
        }

        notifyListeners();
      });
  }

  get percentOpen => _animationController.value;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Open the drawer programmatically
  void open() {
    _animationController.forward();
  }

  /// Close the drawer programmatically
  close(Function onClosedFinished) {
    _animationController.reverse().then((value) => onClosedFinished());
  }

  /// Toggle the drawer programmatically
  /// IMPORTANT : toggle function is buggy
  /// Best use is [open] or [close] function
  void toggle() {
    if (state == SenseiDrawerState.open) {
      close(() {});
    } else if (state == SenseiDrawerState.closed) {
      open();
    }
  }
}
