import 'package:dailyjournal/models/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddTask extends StatefulWidget {
  static const String id = "add_task";

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  int priorityValue = 1;

  TextEditingController titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  GlobalKey<ScaffoldState> _addTaskState = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _titleKey = GlobalKey<FormState>();

  void addTask() async {
    final Box box = Hive.box<Task>('tasks');
    final Task task = Task(
      titleController.text,
      _descController.text,
      false,
      priorityValue,
      priorityValue,
      DateTime.now(),
    );
    box.add(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _addTaskState,
      appBar: AppBar(
        title: Text('Add a Task'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // _titleKey.currentState.validate();
          if (_titleKey.currentState.validate()) {
            addTask();
            Navigator.pop(context);
          }
        },
        label: Text('Save'),
      ),
      body: ListView(
        children: [
          Form(
            key: _titleKey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextFormField(
                    autovalidate: true,
                    autofocus: false,
                    controller: titleController,
                    validator: (val) {
                      if (val.trim().isEmpty) return 'Title can not be empty.';
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18)),
                      labelText: 'Title',
                      labelStyle: TextStyle(fontFamily: 'pac'),
                    ),
                    minLines: 1,
                    maxLines: 2,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _descController,
                    autofocus: false,
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18)),
                      labelText: 'Description',
                      labelStyle: TextStyle(fontFamily: 'pac'),
                    ),
                    autovalidate: true,
                    validator: (val) {
                      return val.length > 60
                          ? 'Too Long'
                          : null;
                    },
                    minLines: null,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 28),
          ListTile(
            title: Text(
              'Priority',
              style: TextStyle(fontFamily: 'pac'),
            ),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor:Theme.of(context).scaffoldBackgroundColor,
                icon: Icon(Icons.keyboard_arrow_down),
                elevation: 12,
                style: TextStyle(fontWeight: FontWeight.w300),
                value: priorityValue,
                items: <DropdownMenuItem<dynamic>>[
                  DropdownMenuItem(
                    value: 1,
                    child: Text(
                      'Low',
                      style: TextStyle(
                          color: Colors.greenAccent, fontFamily: 'pac'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text(
                      'Medium',
                      style: TextStyle(
                          color: Colors.yellowAccent, fontFamily: 'pac'),
                    ),
                  ),
                  DropdownMenuItem(
                    child: Text(
                      'High',
                      style:
                          TextStyle(color: Colors.redAccent, fontFamily: 'pac'),
                    ),
                    value: 3,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    priorityValue = value;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
