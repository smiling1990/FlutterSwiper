/**
 * Copyright 2019 Parcel Santa Pte Ltd. All rights reserved.
 *
 * Eddie, enguagns@parcelsanta.com
 *
 * Use of this source code is limited within Parcel Santa company and its related projects.
 */

import 'package:flutter/material.dart';

/// Created On 2020/1/2
/// Description:
///

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

/// Add Controller of loop
/// Transformer between render index of real index
class TransformerPageController extends PageController {
  final bool loop;
  final int itemCount;

  TransformerPageController({
    int initialPage = 0,
    double viewportFraction = 1.0,
    this.loop: false,
    this.itemCount,
  }) : super(
          initialPage: TransformerPageController._getRealIndexFromRenderIndex(
            initialPage ?? 0,
            loop,
            itemCount,
          ),
          viewportFraction: viewportFraction,
        );

  int getRenderIndexFromRealIndex(num index) {
    return _getRenderIndexFromRealIndex(index, loop, itemCount);
  }

  int getRealItemCount() {
    if (itemCount == 0) return 0;
    return loop ? itemCount + kMaxValue : itemCount;
  }

  static _getRenderIndexFromRealIndex(num index, bool loop, int itemCount) {
    if (itemCount == 0) return 0;
    int renderIndex;
    if (loop) {
      renderIndex = index - kMiddleValue;
      renderIndex = renderIndex % itemCount;
      if (renderIndex < 0) {
        renderIndex += itemCount;
      }
    } else {
      renderIndex = index;
    }
    return renderIndex;
  }

  int getRealIndexFromRenderIndex(num index) {
    return _getRealIndexFromRenderIndex(index, loop, itemCount);
  }

  static int _getRealIndexFromRenderIndex(num index, bool loop, int itemCount) {
    int result = index;
    if (loop) {
      result += kMiddleValue;
    }
    return result;
  }
}
