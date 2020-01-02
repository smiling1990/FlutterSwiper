/**
 * Flutter
 *
 * Eddie, enguagns2@gamil.com
 *
 * https://juejin.im/user/5acd7f706fb9a028d375c045
 *
 */

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class SwiperController extends ChangeNotifier {
  /// Previous
  static const int PREVIOUS = -1;

  /// Moving
  static const int MOVE = 0;

  /// Next
  static const int NEXT = 1;

  /// AutoPlay is started
  static const int START_AUTO_PLAY = 2;

  /// AutoPlay is stopped.
  static const int STOP_AUTO_PLAY = 3;

  Completer _completer;

  /// Cur index
  int index;

  bool animation;

  bool autoPlay;

  int event;

  SwiperController();

  void startAutoPlay() {
    event = SwiperController.START_AUTO_PLAY;
    this.autoPlay = true;
    notifyListeners();
  }

  void stopAutoPlay() {
    event = SwiperController.STOP_AUTO_PLAY;
    this.autoPlay = false;
    notifyListeners();
  }

  Future next({bool animation: true}) {
    this.event = NEXT;
    this.animation = animation ?? true;
    _completer = Completer();
    notifyListeners();
    return _completer.future;
  }

  Future previous({bool animation: true}) {
    this.event = PREVIOUS;
    this.animation = animation ?? true;
    _completer = Completer();
    notifyListeners();
    return _completer.future;
  }

  void complete() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
}
