import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'add_widget.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  String title = 'Future';
  final List<Widget> _children = [
    Add(),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green),
    PlaceholderWidget(Colors.redAccent)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30.0,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text('新增任务')),
          new BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), title: Text('TodoList')),
          new BottomNavigationBarItem(
              icon: Icon(Icons.timeline), title: Text('我的日程')),
          new BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), title: Text('我的喜欢'))
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          title = '新增任务';
          break;
        case 1:
          title = '任务列表';
          break;
        case 2:
          title = '我的日程';
          break;
        case 3:
          title = '我的喜欢';
          break;
        default:
      }
    });
  }
}
