/**
 * Flutter
 *
 * Eddie, enguagns2@gamil.com
 *
 * https://juejin.im/user/5acd7f706fb9a028d375c045
 *
 */

import 'dart:async';
import 'swiper_controller.dart';
import 'swiper_pagination.dart';
import 'transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'transformer_page_controller.dart';

typedef void SwiperOnTap(int index);

/// Default auto play delay
const int kDefaultAutoPlayDelayMs = 3000;

///  Default auto play transition duration (in millisecond)
const int kDefaultAutoPlayTransactionDuration = 300;

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

class Swiper extends StatefulWidget {
  /// Build item on index
  final IndexedWidgetBuilder itemBuilder;

  /// Count of the display items
  final int itemCount;

  final ValueChanged<int> onIndexChanged;

  /// auto play config
  final bool autoPlay;

  /// Duration of the animation between transactions (in millisecond).
  final int autoPlayDelay;

  /// disable auto play when interaction
  final bool autoPlayDisableOnInteraction;

  ///a uto play transition duration (in millisecond)
  final int duration;

  /// transition curve
  final Curve curve;

  /// Set to false to disable continuous loop mode.
  final bool loop;

  final int index;

  /// Called when tap
  final SwiperOnTap onTap;

  ///
  final SwiperController controller;

  ///
  final double viewportFraction;

  // Pagination
  final SwiperPagination swiperPagination;

  Swiper({
    @required this.itemCount,
    @required this.itemBuilder,
    this.autoPlay: false,
    this.autoPlayDelay: kDefaultAutoPlayDelayMs,
    this.autoPlayDisableOnInteraction: true,
    this.duration: kDefaultAutoPlayTransactionDuration,
    this.onIndexChanged,
    this.index,
    this.onTap,
    this.loop: true,
    this.curve: Curves.ease,
    Key key,
    this.controller,
    this.viewportFraction: 1.0,
    this.swiperPagination,
  })  : assert(itemCount != null),
        assert(
          itemBuilder != null,
          "itemBuilder and transformItemBuilder must not be both null",
        ),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SwiperState();
}

/// Controller auto play and stop
abstract class _SwiperTimerMixin extends State<Swiper> {
  Timer _timer;

  SwiperController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    _controller ??= SwiperController();
    _controller.addListener(_onController);
    _handleAutoPlay();
    super.initState();
  }

  void _onController() {
    switch (_controller.event) {
      case SwiperController.START_AUTO_PLAY:
        if (_timer == null) _startAutoPlay();
        break;
      case SwiperController.STOP_AUTO_PLAY:
        if (_timer != null) _stopAutoPlay();
        break;
    }
  }

  @override
  void didUpdateWidget(Swiper oldWidget) {
    if (_controller != oldWidget.controller) {
      if (oldWidget.controller != null) {
        oldWidget.controller.removeListener(_onController);
        _controller = oldWidget.controller;
        _controller.addListener(_onController);
      }
    }
    _handleAutoPlay();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onController);
    _stopAutoPlay();
    super.dispose();
  }

  bool get autoPlayEnabled => _controller.autoPlay ?? widget.autoPlay;

  void _handleAutoPlay() {
    if (autoPlayEnabled && _timer != null) return;
    _stopAutoPlay();
    if (autoPlayEnabled) _startAutoPlay();
  }

  void _startAutoPlay() {
    assert(_timer == null, "Timer must be stopped before start!");
    _timer = Timer.periodic(
      Duration(milliseconds: widget.autoPlayDelay),
      _onTimer,
    );
  }

  void _onTimer(Timer timer) => _controller.next(animation: true);

  void _stopAutoPlay() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}

/// Note: activeIndex does not contain kMiddleValue
class _SwiperState extends _SwiperTimerMixin {
  int _activeIndex;

  TransformerPageController _pageController;

  Widget _wrapTap(BuildContext context, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onTap(index),
      child: widget.itemBuilder(context, index),
    );
  }

  @override
  void initState() {
    _activeIndex = widget.index ?? 0;
    _pageController = TransformerPageController(
      initialPage: widget.index,
      loop: widget.loop,
      itemCount: widget.itemCount,
      viewportFraction: widget.viewportFraction,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(Swiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_pageController == null ||
        (widget.index != oldWidget.index ||
            widget.loop != oldWidget.loop ||
            widget.itemCount != oldWidget.itemCount ||
            widget.viewportFraction != oldWidget.viewportFraction)) {
      _pageController = TransformerPageController(
        initialPage: widget.index,
        loop: widget.loop,
        itemCount: widget.itemCount,
        viewportFraction: widget.viewportFraction,
      );
    }
    if (widget.index != null && widget.index != _activeIndex) {
      _activeIndex = widget.index;
    }
  }

  void _onIndexChanged(int index) {
    setState(() => _activeIndex = index);
    if (widget.onIndexChanged != null) widget.onIndexChanged(index);
  }

  Widget _buildSwiper() {
    IndexedWidgetBuilder itemBuilder;
    if (widget.onTap != null) {
      itemBuilder = _wrapTap;
    } else {
      itemBuilder = widget.itemBuilder;
    }
    Widget child = TransformerPageView(
      pageController: _pageController,
      loop: widget.loop,
      itemCount: widget.itemCount,
      itemBuilder: itemBuilder,
      viewportFraction: widget.viewportFraction,
      index: _activeIndex,
      duration: Duration(milliseconds: widget.duration),
      onPageChanged: _onIndexChanged,
      curve: widget.curve,
      controller: _controller,
    );
    if (widget.autoPlayDisableOnInteraction && widget.autoPlay) {
      return NotificationListener(
        child: child,
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollStartNotification) {
            if (notification.dragDetails != null) {
              // by human
              if (_timer != null) _stopAutoPlay();
            }
          } else if (notification is ScrollEndNotification) {
            if (_timer == null) _startAutoPlay();
          }
          return false;
        },
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    Widget swiper = _buildSwiper();
    if (widget.swiperPagination == null) return swiper;
    SwiperPaginationConfig paginationConfig = SwiperPaginationConfig(
      itemCount: widget.itemCount,
      pageController: _pageController,
      activeIndex: _activeIndex,
      swiperController: widget.controller,
      loop: widget.loop,
    );
    List<Widget> stackWidget = [
      swiper,
      widget.swiperPagination.build(context, paginationConfig),
    ];
    return Stack(
      alignment: Alignment.bottomCenter,
      children: stackWidget,
    );
  }
}
