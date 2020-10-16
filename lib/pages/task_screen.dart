import 'package:dailyjournal/models/task.dart';
import 'package:dailyjournal/utils/gradient_colors.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koukicons/todoList.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Box<Task> taskBox;

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box('tasks');
  }

  Color getPriorityColor(int v) {
    if (v == 1)
      return Colors.greenAccent;
    else if (v == 2)
      return Colors.yellowAccent;
    else if (v == 3)
      return Colors.redAccent;
    else
      return Colors.grey;
  }

  void handleOptions(int index, Task task) {
    showModalBottomSheet(
        elevation: 28,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        )),
        context: context,
        builder: (context) {
          return Container(
            height: 100,
            child: Center(
              child: OutlineButton(
                shape: CircleBorder(),
                onPressed: () {
                  taskBox.deleteAt(index);
                  Navigator.pop(context);
                },
                child: Icon(Icons.delete),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: taskBox.listenable(),
      builder: (BuildContext context, Box<Task> value, Widget child) {
        return value.length != 0
            ? ListView.builder(
                itemCount: value.length,
                itemBuilder: (BuildContext context, int index) {
                  final Task task = value.getAt(index);
                  var grad =
                      GradientTemplate.gradientTemplate[index % 10].colors;

                  return GestureDetector(
                    onLongPress: () {
                      handleOptions(index, task);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(0xFF444974),
                            gradient: task.isCompleted
                                ? null
                                : LinearGradient(
                                    colors: grad,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                            boxShadow: [
                              BoxShadow(
                                color: grad.last.withOpacity(0.5),
                                blurRadius: 8,
                                offset: Offset(2, 2),
                              ),
                              BoxShadow(
                                color: Color(0xff444974).withOpacity(0.3),
                                blurRadius: 8,
                                // spreadRadius: 2,
                                // offset: Offset(4,4),
                              ),
                            ]),
                        child: ListTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationStyle: TextDecorationStyle.wavy,
                              decorationColor: Theme.of(context).accentColor,
                              decorationThickness: 2,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Text(
                            task.description,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 14,
                            ),
                          ),
                          leading: VerticalDivider(
                            color: getPriorityColor(task.priority),
                            thickness: 5,
                          ),
                          trailing: Checkbox(
                            value: task.isCompleted,
                            onChanged: (bool value) {
                              if (task.isCompleted == false) {
                                taskBox.putAt(
                                    index,
                                    Task(task.title, task.description, true, 4,
                                        task.originalPriority, task.dateTime));
                              } else {
                                taskBox.putAt(
                                  index,
                                  Task(
                                      task.title,
                                      task.description,
                                      false,
                                      task.originalPriority,
                                      task.originalPriority,
                                      task.dateTime),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KoukiconsTodoList(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No Task Left'),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}

/*
* Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        elevation: 12,
                        shadowColor:
                            getPriorityColor(task.priority).withOpacity(0.5),
                        child: ListTile(
                          title: Text(task.title, style: TextStyle(
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            decorationStyle: TextDecorationStyle.wavy,
                            decorationColor: Theme.of(context).accentColor,
                            decorationThickness: 2,
                          ),),
                          isThreeLine: true,
                          subtitle: Text(
                            task.description,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w200),
                          ),
                          leading: VerticalDivider(
                            color: getPriorityColor(task.priority),
                            thickness: 3,
                            width: 3,
                          ),
                          trailing: Checkbox(
                            value: task.isCompleted,
                            onChanged: (bool value) {
                              if (task.isCompleted == false) {
                                taskBox.putAt(
                                    index,
                                    Task(task.title, task.description, true, 4,
                                        task.originalPriority, task.dateTime));
                              } else {
                                taskBox.putAt(
                                  index,
                                  Task(
                                      task.title,
                                      task.description,
                                      false,
                                      task.originalPriority,
                                      task.originalPriority,
                                      task.dateTime),
                                );
                              }
                            },
                          ),
                        ),
                      ),*/
