/**
 * Flutter
 *
 * Eddie, enguagns2@gamil.com
 *
 * https://juejin.im/user/5acd7f706fb9a028d375c045
 *
 */

import 'swiper.dart';
import '../config.dart';
import 'swiper_controller.dart';
import 'package:flutter/material.dart';

/// Created On 2019/12/30
/// Description: 第四步
/// 实现自动轮播及转换动画

class DFourthPage extends StatefulWidget {
  @override
  _DFourthPageState createState() => _DFourthPageState();
}

class _DFourthPageState extends State<DFourthPage> {
  /// SwiperController
  SwiperController _swiperController;

  /// Current Index
  int _curIndex;

  @override
  void initState() {
    // Init
    _curIndex = 0;
    _swiperController = SwiperController();
    super.initState();
  }

  _buildItems(ImageItemData itemData) {
    return Container(
      padding: EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            child: Image.asset(itemData.assets, fit: BoxFit.cover),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                ),
              ),
              child: Text(
                itemData.title,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildButton({String text, VoidCallback onPressed}) {
    return RaisedButton(
      onPressed: onPressed,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      padding: EdgeInsets.all(12.0),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('4. 实现自动轮播及转换动画')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        children: <Widget>[
          Container(
            height: 200.0,
            child: Swiper(
              index: _curIndex,
              viewportFraction: 0.8,
              controller: _swiperController,
              itemCount: Config.imagesData.length,
              itemBuilder: (context, index) {
                return _buildItems(Config.imagesData[index]);
              },
              onIndexChanged: (index) {
                setState(() {
                  _curIndex = index;
                  print('-->>onIndexChanged: $index');
                });
              },
              loop: true,
              autoPlay: true,
              duration: 1000,
              autoPlayDelay: 2000,
              autoPlayDisableOnInteraction: true,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
            child: Text('Current Index: $_curIndex'),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 12.0,
              runSpacing: 8.0,
              children: <Widget>[
                // Previous
                _buildButton(
                  text: 'PREVIOUS',
                  onPressed: () {
                    _swiperController.previous();
                  },
                ),
                // Next
                _buildButton(
                  text: 'NEXT',
                  onPressed: () {
                    _swiperController.next();
                  },
                ),
                // Next
                _buildButton(
                  text: 'START AUTOPLAY',
                  onPressed: () {
                    _swiperController.startAutoPlay();
                  },
                ),
                // Next
                _buildButton(
                  text: 'STOP AUTOPLAY',
                  onPressed: () {
                    _swiperController.stopAutoPlay();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _swiperController?.dispose();
    super.dispose();
  }
}
