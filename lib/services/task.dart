import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app/models/task.dart';

final String tableTask = 'task';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDeadline = 'deadline';

class TaskSqlite {
  Database db;

  openSqlite() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'b2d1.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
                      create table $tableTask ( 
                        $columnId integer primary key autoincrement, 
                        $columnTitle text not null,
                        $columnDeadline integer not null)
                      ''');
    });
  }

  // find Tasks
  Future<List<Task>> queryAll() async {
    List<Map> maps = await db
        .query(tableTask, columns: [columnId, columnTitle, columnDeadline]);
    if (maps == null || maps.length == 0) {
      return null;
    }
    List<Task> tasks = [];
    for (int i = 0; i < maps.length; i++) {
      Task task = Task.fromMap(maps[i]);
      tasks.add(task);
    }

    return tasks;
  }

  // add Task
  Future<Task> insert(Task task) async {
    task.id = await db.insert(tableTask, task.toMap());
    return task;
  }

  // find Task
  Future<Task> getTask(int id) async {
    List<Map> maps = await db.query(tableTask,
        columns: [
          columnId,
          columnTitle,
          columnDeadline,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  // delete Task
  Future<int> delete(int id) async {
    return await db.delete(tableTask, where: '$columnId = ?', whereArgs: [id]);
  }

  // update Task
  Future<int> update(Task task) async {
    return await db.update(tableTask, task.toMap(),
        where: '$columnId = ?', whereArgs: [task.id]);
  }

  // close database
  Future close() async {
    return await db.close();
  }
}
