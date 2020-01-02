/**
 * Flutter
 *
 * Eddie, enguagns2@gamil.com
 *
 * https://juejin.im/user/5acd7f706fb9a028d375c045
 *
 */

import 'a_first/a_first_page.dart';
import 'b_second/b_second_page.dart';
import 'c_third/c_third_page.dart';
import 'd_fourth/d_fourth_page.dart';
import 'package:flutter/material.dart';

import 'e_fifth/e_fifth_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Swipe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF0F0F0),
        appBarTheme: AppBarTheme(
          color: Colors.blue,
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      home: MyHomePage(),
      routes: {
        '/a_first': (c) => AFirstPage(),
        '/b_second': (c) => BSecondPage(),
        '/c_third': (c) => CThirdPage(),
        '/d_fourth': (c) => DFourthPage(),
        '/e_fifth': (c) => EFifthPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Items
  List<TileItemEntity> _itemsData;

  @override
  void initState() {
    super.initState();
    // Init
    _itemsData = [
      TileItemEntity(
        title: '第一步',
        subtitle: '初步封装PageView',
        pageRoute: '/a_first',
      ),
      TileItemEntity(
        title: '第二步',
        subtitle: '自定义SwiperController',
        pageRoute: '/b_second',
      ),
      TileItemEntity(
        title: '第三步',
        subtitle: '实现无限循环',
        pageRoute: '/c_third',
      ),
      TileItemEntity(
        title: '第四步',
        subtitle: '实现自动轮播及转换动画',
        pageRoute: '/d_fourth',
      ),
      TileItemEntity(
        title: '第五步',
        subtitle: '实现页码展示',
        pageRoute: '/e_fifth',
      ),
    ];
  }

  List<Widget> _buildChildren(BuildContext context) {
    return ListTile.divideTiles(
      context: context,
      color: Colors.white,
      tiles: _itemsData.map((TileItemEntity item) {
        return _buildChild(item);
      }),
    ).toList();
  }

  Widget _buildChild(TileItemEntity item) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(item.pageRoute),
      title: Text(item.title),
      subtitle: Text(item.subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Swipe'),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: _buildChildren(context),
      ),
    );
  }
}

class TileItemEntity {
  String title;
  String subtitle;
  String pageRoute;

  TileItemEntity({
    this.title,
    this.subtitle,
    this.pageRoute,
  });
}
