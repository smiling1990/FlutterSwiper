/**
 * Flutter
 *
 * Eddie, enguagns2@gamil.com
 *
 * https://juejin.im/user/5acd7f706fb9a028d375c045
 *
 */

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Created On 2019/12/30
/// Description: 第三步
/// 实现无限循环

class SwiperController extends ChangeNotifier {
  /// Next page
  static const int NEXT = 1;

  /// Previous page
  static const int PREVIOUS = -1;

  Completer _completer;

  /// Current index
  int index;

  /// Current event
  int event;

  SwiperController();

  Future next() {
    this.event = NEXT;
    _completer = Completer();
    notifyListeners();
    return _completer.future;
  }

  Future previous() {
    this.event = PREVIOUS;
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
