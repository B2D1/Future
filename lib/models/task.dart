final String tableTask = 'task';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDeadline = 'deadline';

class Task {
  int id;
  String title;
  int deadline;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnTitle: title, columnDeadline: deadline};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Task(String title, int deadline) {
    this.title = title;
    this.deadline = deadline;
  }

  Task.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    deadline = map[columnDeadline];
  }
}
