/**
 * Copyright 2019 Parcel Santa Pte Ltd. All rights reserved.
 *
 * Eddie, enguagns@parcelsanta.com
 *
 * Use of this source code is limited within Parcel Santa company and its related projects.
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
