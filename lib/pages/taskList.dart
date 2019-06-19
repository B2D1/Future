import 'dart:math';

import 'package:app/models/task.dart';
import 'package:app/services/task.dart';
import 'package:flutter/material.dart';

class TaskList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskListState();
  }
}

class _TaskListState extends State<TaskList> {
  TaskSqlite taskSqlite = new TaskSqlite();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tasks == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(32),
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: new SizedBox(
                        child: new Card(
                          elevation: 15.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child: new Column(
                            children: [
                              new ListTile(
                                title: new Text(tasks[index].title,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w500)),
                                trailing: new Icon(
                                  Icons.close,
                                  color: Colors.blue[500],
                                ),
                                onTap: () {
                                  deleteTask(tasks[index].id);
                                  tasks.removeAt(index);
                                  setState(() {
                                    tasks = tasks;
                                  });
                                },
                              ),
                              new Divider(),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: new Icon(
                                        Icons.access_time,
                                        color: Colors.blue[500],
                                      ),
                                    ),
                                    new Text(
                                        new DateTime.fromMillisecondsSinceEpoch(
                                                (tasks[index].deadline))
                                            .toString()
                                            .substring(0, 10),
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: new Text(
                                          timeTip(tasks[index].deadline)
                                              .toString(),
                                          style: new TextStyle(
                                              color: calcPassDay(tasks[index]
                                                          .deadline) >
                                                      0
                                                  ? Colors.blue
                                                  : Colors.red),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
    );
  }

  int calcPassDay(int timestamp) {
    int seconds = timestamp - new DateTime.now().millisecondsSinceEpoch;
    return (seconds / 86400000).ceil();
  }

  String timeTip(int timestamp) {
    int day = calcPassDay(timestamp);
    if (day > 0) {
      return '还有 ' + day.toString() + ' 天';
    } else {
      return '已经过去了 ' + day.abs().toString() + ' 天';
    }
  }

  void fetchTasks() async {
    await taskSqlite.openSqlite();
    tasks = await taskSqlite.queryAll();
    setState(() {
      tasks = tasks;
    });
    await taskSqlite.close();
  }

  void deleteTask(int id) async {
    await taskSqlite.openSqlite();
    await taskSqlite.delete(id);
    await taskSqlite.close();
  }
}
