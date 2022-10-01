import 'dart:convert';

class Task {
  String title;
  String time;
  String day;
  String status;
  Task({this.title = '', this.time = '', this.day = '', this.status = 'new'});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'time': time,
      'day': day,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] as String,
      time: map['time'] as String,
      day: map['day'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
}
