import 'swiper_controller.dart';
import 'package:flutter/widgets.dart';
import 'transformer_page_controller.dart';

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

///  Default auto play transition duration (in millisecond)
const int kDefaultTransactionDuration = 300;

class TransformerPageView extends StatefulWidget {
  /// Same as [PageView.onPageChanged]
  final ValueChanged<int> onPageChanged;

  final IndexedWidgetBuilder itemBuilder;

  final SwiperController controller;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  final TransformerPageController pageController;

  /// Set true to open infinity loop mode.
  final bool loop;

  /// This value is only valid when `pageController` is not set,
  final int itemCount;

  /// This value is only valid when `pageController` is not set,
  final double viewportFraction;

  /// If not set, it is controlled by this widget.
  final int index;

  TransformerPageView({
    Key key,
    this.index,
    Duration duration,
    this.curve: Curves.ease,
    this.viewportFraction: 1.0,
    this.loop: false,
    this.onPageChanged,
    this.controller,
    this.itemBuilder,
    this.pageController,
    @required this.itemCount,
  })  : assert(itemCount != null),
        assert(itemCount == 0 || itemBuilder != null),
        this.duration = duration ??
            Duration(
              milliseconds: kDefaultTransactionDuration,
            ),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TransformerPageViewState();
}

class _TransformerPageViewState extends State<TransformerPageView> {
  int _activeIndex;

  /// As [SwiperController]
  ChangeNotifier _swiperController;

  TransformerPageController _pageController;

  Widget _buildItemNormal(BuildContext context, int index) {
    int renderIndex = _pageController.getRenderIndexFromRealIndex(index);
    return widget.itemBuilder(context, renderIndex);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: _buildItemNormal,
      itemCount: _pageController.getRealItemCount(),
      onPageChanged: _onIndexChanged,
      controller: _pageController,
    );
  }

  void _onIndexChanged(int index) {
    _activeIndex = index;
    if (widget.onPageChanged != null) {
      widget.onPageChanged(_pageController.getRenderIndexFromRealIndex(index));
    }
  }

  @override
  void initState() {
    _pageController = widget.pageController;
    if (_pageController == null) {
      _pageController = TransformerPageController(
        initialPage: widget.index,
        itemCount: widget.itemCount,
        loop: widget.loop,
      );
    }
    _activeIndex = _pageController.initialPage;
    _swiperController = widget.controller;
    if (_swiperController != null) {
      _swiperController.addListener(onChangeNotifier);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(TransformerPageView oldWidget) {
    int index = widget.index ?? 0;
    bool created = false;
    // PageController changed
    // Here '_pageController' is oldWidget.pageController
    if (_pageController != widget.pageController) {
      if (widget.pageController != null) {
        _pageController = widget.pageController;
      } else {
        created = true;
        _pageController = TransformerPageController(
          initialPage: widget.index,
          itemCount: widget.itemCount,
          loop: widget.loop,
        );
      }
    }
    // Index changed
    if (_pageController.getRenderIndexFromRealIndex(_activeIndex) != index) {
      _activeIndex = _pageController.initialPage;
      if (!created) {
        int initPage = _pageController.getRealIndexFromRenderIndex(index);
        _pageController.animateToPage(
          initPage,
          duration: widget.duration,
          curve: widget.curve,
        );
      }
    }
    // SwiperController changed
    if (_swiperController != widget.controller) {
      if (_swiperController != null) {
        _swiperController.removeListener(onChangeNotifier);
      }
      _swiperController = widget.controller;
      if (_swiperController != null) {
        _swiperController.addListener(onChangeNotifier);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void onChangeNotifier() {
    int event = widget.controller.event;
    int index;
    switch (event) {
      case SwiperController.PREVIOUS:
      case SwiperController.NEXT:
        index = _calcNextIndex(event == SwiperController.NEXT);
        break;
      default:
        return;
    }
    if (widget.controller.animation) {
      _pageController
          .animateToPage(
            index,
            duration: widget.duration,
            curve: widget.curve ?? Curves.ease,
          )
          .whenComplete(
            widget.controller.complete,
          );
    } else {
      _pageController.jumpToPage(index);
      widget.controller.complete();
    }
  }

  int _calcNextIndex(bool next) {
    int currentIndex = _activeIndex;
    if (next) {
      currentIndex++;
    } else {
      currentIndex--;
    }
    if (!_pageController.loop) {
      if (currentIndex >= _pageController.itemCount) {
        currentIndex = 0;
      } else if (currentIndex < 0) {
        currentIndex = _pageController.itemCount - 1;
      }
    }
    return currentIndex;
  }

  void dispose() {
    _swiperController?.removeListener(onChangeNotifier);
    super.dispose();
  }
}
