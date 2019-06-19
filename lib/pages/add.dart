import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/services/todo.dart';
import 'package:app/models/todo.dart';
import 'package:app/services/task.dart';
import 'package:app/models/task.dart';

class Add extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddState();
  }
}

class _AddState extends State<Add> {
  TodoSqlite todoSqlite = new TodoSqlite();
  TaskSqlite taskSqlite = new TaskSqlite();
  String taskDate = '';
  int taskTimestamp = 0;
  String todoContent = '';
  String taskTitle = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 32, top: 30),
                child: Text(
                  '新增Todo',
                  textScaleFactor: 2,
                ),
              )
            ],
          ),
          Padding(
              padding:
                  EdgeInsets.only(left: 32, right: 32, top: 24, bottom: 24),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "内容",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: "输入您计划的任务",
                    prefixIcon: Icon(Icons.turned_in_not)),
                onChanged: (v) {
                  todoContent = v;
                },
              )),
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 32),
                  child: RaisedButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue[700],
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    child: Text('添加'),
                    onPressed: () {
                      addTodo(todoContent);
                    },
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(32),
            child: new Divider(),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 32),
                child: Text(
                  '新增日程',
                  textScaleFactor: 2,
                ),
              )
            ],
          ),
          Padding(
              padding:
                  EdgeInsets.only(left: 32, right: 32, top: 24, bottom: 24),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "内容",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: "输入您计划的日程",
                    prefixIcon: Icon(Icons.calendar_today)),
                onChanged: (v) {
                  setState(() {
                    taskTitle = v;
                  });
                },
              )),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 32, right: 24),
                child: RaisedButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue[700],
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    onPressed: () {
                      DatePicker.showDatePicker(context, showTitleActions: true,
                          onConfirm: (date) {
                        setState(() {
                          taskDate = date.toString();
                          taskTimestamp = generateTimestamp(date);
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.zh);
                    },
                    child: Text(
                      '选择日程',
                    )),
              ),
              Text('您选择了 ' + formatTime(taskDate))
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 32,top: 24),
                  child: RaisedButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue[700],
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    child: Text('添加'),
                    onPressed: () {
                      addTask(taskTitle, taskTimestamp);
                    },
                  )),
            ],
          ),
        ],
      ),
    );
  }

  // format pickDateTime
  String formatTime(String time) {
    if (time.length > 9) {
      return time.substring(0, 10);
    }
    return time;
  }

  // generate timestamp
  int generateTimestamp(DateTime date) {
    String dateString = date.toString();
    int year = int.parse(dateString.substring(0, 4));
    int month = int.parse(dateString.substring(5, 7));
    int day = int.parse(dateString.substring(8, 10));
    return new DateTime(year, month, day).millisecondsSinceEpoch;
  }

  // showToast
  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  // showToast
  void showErrorToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  // add Todo
  void addTodo(String content) async {
    if (content.length == 0) {
      showErrorToast('内容不能为空！');
      return;
    }
    await todoSqlite.openSqlite();
    await todoSqlite.insert(new Todo(content, false));
    showToast('添加 Todo 成功 (ﾟ▽ﾟ)/');
    await todoSqlite.close();
  }

  // add Task
  void addTask(String title, int timestamp) async {
    if (title.length == 0) {
      showErrorToast('内容不能为空！');
      return;
    }
    if (timestamp == 0) {
      showErrorToast('请选择日程！');
      return;
    }
    await taskSqlite.openSqlite();
    await taskSqlite.insert(new Task(title, timestamp));
    showToast('添加日程成功 (ﾟ▽ﾟ)/');
    await taskSqlite.close();
  }
}
