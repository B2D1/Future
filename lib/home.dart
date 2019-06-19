import 'package:flutter/material.dart';
import 'pages/add.dart';
import 'pages/todoList.dart';
import 'pages/doneList.dart';
import 'pages/taskList.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  String title = 'Future';
  final List<Widget> _children = [Add(), TodoList(), DoneList(), TaskList()];
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
              icon: Icon(Icons.add_circle), title: Text('新增任务')),
          new BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), title: Text('待办任务')),
          new BottomNavigationBarItem(
              icon: Icon(Icons.check_box), title: Text('完成任务')),
          new BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_day), title: Text('我的日程')),
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
          title = '待办任务';
          break;
        case 2:
          title = '完成任务';
          break;
        case 3:
          title = '我的日程';
          break;
        default:
      }
    });
  }
}
