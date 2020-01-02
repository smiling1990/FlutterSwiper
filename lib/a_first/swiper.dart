/**
 * Copyright 2019 Parcel Santa Pte Ltd. All rights reserved.
 *
 * Eddie, enguagns@parcelsanta.com
 *
 * Use of this source code is limited within Parcel Santa company and its related projects.
 */

import 'package:flutter/material.dart';

/// Created On 2019/12/29
/// Description: 第一步
/// 初步封装PageView

typedef void SwiperOnTap(int index);

class Swiper extends StatefulWidget {
  /// count of the display items
  final int itemCount;

  final ValueChanged<int> onIndexChanged;

  /// Index number of initial slide.
  final int index;

  /// Called when tap
  final SwiperOnTap onTap;

  ///
  final double viewportFraction;

  /// Build item on index
  final IndexedWidgetBuilder itemBuilder;

  const Swiper({
    Key key,
    this.itemBuilder,
    @required this.itemCount,
    this.onIndexChanged,
    this.index,
    this.onTap,
    this.viewportFraction,
  }) : super(key: key);

  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  /// PageController
  PageController _pageController;

  /// Active Page Index
  int _activeIndex;

  @override
  void initState() {
    // Init
    _activeIndex = widget.index ?? 0;
    _pageController = PageController(
      initialPage: _activeIndex,
      viewportFraction: widget.viewportFraction ?? 1.0,
    );
    super.initState();
  }

  Widget _wrapTap(BuildContext context, int index) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        this.widget.onTap(index);
      },
      child: widget.itemBuilder(context, index),
    );
  }

  Widget _buildSwiper() {
    IndexedWidgetBuilder itemBuilder;
    if (widget.onTap != null) {
      itemBuilder = _wrapTap;
    } else {
      itemBuilder = widget.itemBuilder;
    }
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.itemCount,
      itemBuilder: itemBuilder,
      onPageChanged: widget.onIndexChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSwiper();
  }
}
