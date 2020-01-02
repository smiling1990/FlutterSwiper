/**
 * Copyright 2019 Parcel Santa Pte Ltd. All rights reserved.
 *
 * Eddie, enguagns@parcelsanta.com
 *
 * Use of this source code is limited within Parcel Santa company and its related projects.
 */

import 'swiper_controller.dart';
import 'package:flutter/material.dart';

/// Created On 2019/12/30
/// Description: 第三步
/// 实现无限循环

typedef void SwiperOnTap(int index);

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

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

  /// SwiperController
  final SwiperController swiperController;

  /// Set to false to disable continuous loop mode.
  final bool loop;

  const Swiper({
    Key key,
    this.itemBuilder,
    @required this.itemCount,
    this.onIndexChanged,
    this.index,
    this.onTap,
    this.viewportFraction,
    this.swiperController,
    this.loop: true,
  }) : super(key: key);

  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  /// SwiperController
  SwiperController _swiperController;

  /// PageController
  PageController _pageController;

  /// Active Page Index: 0,1,2...
  int _activeIndex;

  @override
  void initState() {
    super.initState();
    // Init
    _activeIndex = widget.index ?? 0;
    _pageController = PageController(
      initialPage: getRealIndexFromRenderIndex(
        index: _activeIndex,
        loop: widget.loop,
      ),
      viewportFraction: widget.viewportFraction ?? 1.0,
    );
    // SwiperController
    _swiperController = widget.swiperController;
    _swiperController.addListener(_onController);
  }

  void _onController() {
    int event = widget.swiperController.event;
    int index = _pageController.page.floor();
    switch (event) {
      case SwiperController.PREVIOUS:
        if (index <= 0) return;
        index--;
        _pageController.jumpToPage(index);
        widget.swiperController.complete();
        _activeIndex = getRenderIndexFromRealIndex(
          index: index,
          loop: widget.loop,
          itemCount: widget.itemCount,
        );
        break;
      case SwiperController.NEXT:
        if (index >= getRealItemCount() - 1) return;
        index++;
        _pageController.jumpToPage(index);
        widget.swiperController.complete();
        _activeIndex = getRenderIndexFromRealIndex(
          index: index,
          loop: widget.loop,
          itemCount: widget.itemCount,
        );
        break;
    }
  }

  int getRealItemCount() {
    if (widget.itemCount == 0) return 0;
    return widget.loop ? widget.itemCount + kMaxValue : widget.itemCount;
  }

  int getRealIndexFromRenderIndex({int index, bool loop}) {
    int initPage = index;
    if (loop) {
      initPage += kMiddleValue;
    }
    return initPage;
  }

  int getRenderIndexFromRealIndex({int index, bool loop, int itemCount}) {
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
      itemCount: getRealItemCount(),
      itemBuilder: (c, i) {
        int renderIndex = getRenderIndexFromRealIndex(
          index: i,
          loop: widget.loop,
          itemCount: widget.itemCount,
        );
        return itemBuilder(context, renderIndex);
      },
      onPageChanged: (index) {
        if (widget.onIndexChanged != null) {
          widget.onIndexChanged(getRenderIndexFromRealIndex(
            index: index,
            loop: widget.loop,
            itemCount: widget.itemCount,
          ));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSwiper();
  }

  @override
  void dispose() {
    _swiperController.removeListener(_onController);
    _swiperController.dispose();
    _swiperController = null;
    super.dispose();
  }
}
