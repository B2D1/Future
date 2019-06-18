import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app/models/todo.dart';

final String tableTodo = 'todo';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';

class TodoSqlite {
  Database db;

  openSqlite() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'b2d1.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnDone integer not null)
''');
    });
  }

  // find todos
  Future<List<Todo>> queryAll(bool done) async {
    List<Map> maps =
        await db.query(tableTodo, columns: [columnId, columnTitle, columnDone]);
    if (maps == null || maps.length == 0) {
      return null;
    }
    List<Todo> todos = [];
    for (int i = 0; i < maps.length; i++) {
      Todo todo = Todo.fromMap(maps[i]);
      if (todo.done == done) {
        todos.add(todo);
      }
    }

    return todos;
  }

  // add Todo
  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  // find Todo
  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [
          columnId,
          columnTitle,
          columnDone,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  // delete Todo
  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  // update Todo
  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  // close database
  Future close() async {
    return await db.close();
  }
}
