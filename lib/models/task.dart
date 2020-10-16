import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 2)
class Task {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final bool isCompleted;
  @HiveField(3)
  final int priority;
  @HiveField(4)
  final int originalPriority;
  @HiveField(5)
  final DateTime dateTime;

  Task(this.title, this.description, this.isCompleted, this.priority,
      this.originalPriority, this.dateTime);
}
