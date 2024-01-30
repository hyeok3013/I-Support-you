import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final bool check;

  TaskModel(this.title, this.check);
}
