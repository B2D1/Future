import 'package:app/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:app/services/todo.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoListState();
  }
}

class _TodoListState extends State<TodoList> {
  TodoSqlite todoSqlite = new TodoSqlite();
  List<Todo> todos;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: todos == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (BuildContext context, int index) {
                  return new ListTile(
                    title: new Text(
                      todos[index].title,
                      style: _biggerFont,
                    ),
                    trailing: new Icon(
                      Icons.done,
                    ),
                    onTap: () {
                      updateTodo(todos[index]);
                      todos.removeAt(index);
                      setState(() {
                        todos = todos;
                      });
                    },
                  );
                },
              ),
            ),
    );
  }

  void fetchTodos() async {
    await todoSqlite.openSqlite();
    todos = await todoSqlite.queryAll(false);
    setState(() {
      todos = todos;
    });
    await todoSqlite.close();
  }

  void updateTodo(Todo todo) async {
    await todoSqlite.openSqlite();
    todo.done = true;
    await todoSqlite.update(todo);
    await todoSqlite.close();
  }
}
