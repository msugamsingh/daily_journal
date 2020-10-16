import 'package:dailyjournal/models/note.dart';
import 'package:dailyjournal/pages/add_note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditNote extends StatefulWidget {
  static const String id = 'edit_note';
  final Note note;

  const EditNote({Key key, this.note}) : super(key: key);

  @override
  _EditNoteState createState() => _EditNoteState(note);
}

class _EditNoteState extends State<EditNote> {
  final Note note;
  int achLength;
  int moodValue;

  List<TextEditingController> controllers = [];

  _EditNoteState(this.note) {
    for (var i in note.achievements) {
      controllers.add(TextEditingController());
    }
    achLength = note.achievements.length;
    moodValue = note.mood;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(
              'Mood throughout the day',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgEmoji(
                    name: 'emo1',
                    moodValue: moodValue,
                    value: 1,
                    onSvgTap: () {
                      setState(() {
                        moodValue = 1;
                      });
                    },
                  ),
                  SvgEmoji(
                    name: 'emo2',
                    moodValue: moodValue,
                    value: 2,
                    onSvgTap: () {
                      setState(() {
                        moodValue = 2;
                      });
                    },
                  ),
                  SvgEmoji(
                    name: 'emo3',
                    moodValue: moodValue,
                    value: 3,
                    onSvgTap: () {
                      setState(() {
                        moodValue = 3;
                      });
                    },
                  ),
                  SvgEmoji(
                    name: 'emo4',
                    moodValue: moodValue,
                    value: 4,
                    onSvgTap: () {
                      setState(() {
                        moodValue = 4;
                      });
                    },
                  ),
                  SvgEmoji(
                    name: 'emo5',
                    moodValue: moodValue,
                    value: 5,
                    onSvgTap: () {
                      setState(() {
                        moodValue = 5;
                      });
                    },
                  ),
                  SvgEmoji(
                    name: 'emo6',
                    moodValue: moodValue,
                    value: 6,
                    onSvgTap: () {
                      setState(() {
                        moodValue = 6;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Column(
              children: List.generate(achLength + 1, (index) {
                if (index != achLength) {
                  TextEditingController controller = controllers[index];
                  if (index < note.achievements.length)
                    controller.text = note.achievements[index];
                  return ListTile(
                    leading: Icon(FontAwesomeIcons.dotCircle),
                    title: TextField(
                      controller: controller,
                      key: ValueKey(index),
                      minLines: null,
                      maxLines: null,
                    ),
                  );
                } else
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      shape: CircleBorder(),
                      onPressed: () {
                        if (controllers.last.text.trim().isNotEmpty) {
                          controllers.add(TextEditingController());
                          setState(() {
                            achLength++;
                          });
                        }
                      },
                      child: Icon(CupertinoIcons.add),
                    ),
                  );
              }, growable: true),
            ),
          ],
        ),
      ),
    );
  }
}
