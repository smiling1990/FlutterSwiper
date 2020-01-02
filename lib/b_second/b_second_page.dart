/**
 * Copyright 2019 Parcel Santa Pte Ltd. All rights reserved.
 *
 * Eddie, enguagns@parcelsanta.com
 *
 * Use of this source code is limited within Parcel Santa company and its related projects.
 */

import 'swiper.dart';
import '../config.dart';
import 'swiper_controller.dart';
import 'package:flutter/material.dart';

/// Created On 2019/12/30
/// Description: 第二步
/// 自定义SwiperController

class BSecondPage extends StatefulWidget {
  @override
  _BSecondPageState createState() => _BSecondPageState();
}

class _BSecondPageState extends State<BSecondPage> {
  /// SwiperController
  SwiperController _swiperController;

  @override
  void initState() {
    // Init
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
      appBar: AppBar(title: Text('2. 自定义SwiperController')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        children: <Widget>[
          Container(
            height: 200.0,
            child: Swiper(
              index: 1,
              viewportFraction: 0.8,
              swiperController: _swiperController,
              itemCount: Config.imagesData.length,
              itemBuilder: (context, index) {
                return _buildItems(Config.imagesData[index]);
              },
            ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
