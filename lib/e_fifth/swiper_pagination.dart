/**
 * Copyright 2019 Parcel Santa Pte Ltd. All rights reserved.
 *
 * Eddie, enguagns@parcelsanta.com
 *
 * Use of this source code is limited within Parcel Santa company and its related projects.
 */

import 'swiper_controller.dart';
import 'package:flutter/material.dart';

/// Created On 2020/1/2
/// Description:
///

class SwiperPaginationConfig {
  final int activeIndex;
  final int itemCount;
  final bool loop;
  final PageController pageController;
  final SwiperController swiperController;

  const SwiperPaginationConfig({
    this.activeIndex,
    this.itemCount,
    this.swiperController,
    this.pageController,
    this.loop,
  }) : assert(swiperController != null);
}

/// Here only Dots Pagination
class SwiperPagination {
  /// color when current index,if set null, will be Theme.of(context).primaryColor
  final Color activeColor;

  /// if set null, will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///Size of the dot when activate
  final double activeSize;

  ///Size of the dot
  final double size;

  /// Space between dots
  final double space;

  /// Distance between pagination and the container
  final EdgeInsetsGeometry margin;

  final Key key;

  const SwiperPagination({
    this.key,
    this.activeColor,
    this.color,
    this.size: 10.0,
    this.activeSize: 10.0,
    this.space: 3.0,
    this.margin: const EdgeInsets.all(10.0),
  });

  Widget build(BuildContext context, SwiperPaginationConfig config) {
    Color activeColor = this.activeColor;
    Color color = this.color;
    // Default
    activeColor ??= Theme.of(context).primaryColor;
    color ??= Theme.of(context).scaffoldBackgroundColor;

    List<Widget> children = [];
    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      children.add(Container(
        key: Key("Pagination_$i"),
        margin: EdgeInsets.all(space),
        child: ClipOval(
          child: Container(
            color: active ? activeColor : color,
            width: active ? activeSize : size,
            height: active ? activeSize : size,
          ),
        ),
      ));
    }
    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
