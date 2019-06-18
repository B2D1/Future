import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/services/todo.dart';
import 'package:app/models/todo.dart';

class Add extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddState();
  }
}

class _AddState extends State<Add> {
  TodoSqlite todoSqlite = new TodoSqlite();
  String taskDate = '';
  String bookName = "";
  String todoContent = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, top: 30),
                child: Text(
                  '新增Todo',
                  textScaleFactor: 2,
                ),
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "内容",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: "输入您计划的任务",
                    prefixIcon: Icon(Icons.turned_in_not)),
                onChanged: (value) {
                  todoContent = value;
                },
              )),
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 32),
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
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  '新增日程',
                  textScaleFactor: 2,
                ),
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "内容",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: "输入您计划的日程",
                    prefixIcon: Icon(Icons.calendar_today)),
                onChanged: (v) {},
              )),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: RaisedButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue[700],
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    onPressed: () {
                      DatePicker.showDatePicker(context, showTitleActions: true,
                          onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          taskDate = date.toString();
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

  // add Todo
  void addTodo(String content) async {
    await todoSqlite.openSqlite();
    await todoSqlite.insert(new Todo(1, content, false));
    showToast('添加成功(ﾟ▽ﾟ)/');
    await todoSqlite.close();
  }
}
