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
import 'package:flutter/material.dart';

/// Created On 2019/12/29
/// Description: 第一步
/// 初步封装PageView

class AFirstPage extends StatefulWidget {
  @override
  _AFirstPageState createState() => _AFirstPageState();
}

class _AFirstPageState extends State<AFirstPage> {
  @override
  void initState() {
    // Init
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('1. 初步封装PageView')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        children: <Widget>[
          Container(
            height: 200.0,
            child: Swiper(
              index: 1,
              itemCount: Config.imagesData.length,
              itemBuilder: (context, index) {
                return _buildItems(Config.imagesData[index]);
              },
              viewportFraction: 0.8,
              onTap: (index) {
                print('-->>onTap: $index');
              },
              onIndexChanged: (index) {
                print('-->>onIndexChanged: $index');
              },
            ),
          ),
        ],
      ),
    );
  }
}
