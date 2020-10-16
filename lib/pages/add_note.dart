import 'dart:async';
import 'dart:io';

import 'package:dailyjournal/models/note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddNote extends StatefulWidget {
  static const String id = 'note';
  final Note editNote;
  final editIndex;

  const AddNote({Key key, this.editNote, this.editIndex}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState(editNote, editIndex);
}

class _AddNoteState extends State<AddNote> {
  final Note editNote;
  final editIndex;
  int moodValue = 0;
  Directory appDir;
  List day = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY'
  ];
  int weekDay = 2;

  // List<String> editNotesImgPaths;
  int accLength = 2;
  double imageOpacity = 0;
  bool removeAll = false;
  List<TextEditingController> controllers = [TextEditingController()];
  TextEditingController descriptionController = TextEditingController();
  List<PickedFile> imgFiles = [];
  List<String> imgPaths;
  GlobalKey<ScaffoldState> addNoteScaffold = GlobalKey<ScaffoldState>();

  _AddNoteState([this.editNote, this.editIndex]) {
    if (editNote != null) {
      controllers.clear();
      accLength = editNote.achievements.length;
      if (accLength == 0) accLength = 1;
      for (var _ = 0; _ < accLength; _++) {
        controllers.add(TextEditingController());
      }
      moodValue = editNote.mood;
      descriptionController.text = editNote.description;
      imgPaths = [...editNote.imgPaths];
      if (imgPaths.isEmpty) removeAll = true;
    }
  }

  getAppDir() async {
    appDir = await getApplicationDocumentsDirectory();
    // setState(() {
    //   appDir = d;
    // });
  }

  @override
  void initState() {
    super.initState();
    getAppDir();
    final date = DateTime.now();
    weekDay = date.weekday;
  }

  void addNote() async {
    final Box box = Hive.box<Note>('notes');
    List<String> achieves = [];
    for (var i in controllers) {
      if (i.text.isNotEmpty) achieves.add(i.text);
    }
    String desc = descriptionController.text ?? '';
    List<String> imgList = [];
    for (var i in imgFiles) {
      File f = File(i.path);
      String name = i.path.substring(i.path.lastIndexOf('image_pick'));
      String newPath = appDir.uri.resolve('$name').path;
      File newFile = await f.copy(newPath);
      editNote == null ? imgList.add(newFile.path) : imgPaths.add(newFile.path);
    }
    final Note note = editNote == null
        ? Note(moodValue, achieves, desc, imgList, DateTime.now(), false)
        : Note(moodValue, achieves, desc, imgPaths, editNote.dateTime,
            editNote.isFavorite);
    editNote == null ? box.add(note) : box.putAt(editIndex, note);
  }

  Widget addImageButton(int i) {
    return Visibility(
      visible: editNote == null ? imgFiles.length == i : true,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white70
            : Color(0xFF242634),
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(CupertinoIcons.add),
            onPressed: () async {
              PickedFile file =
                  await ImagePicker().getImage(source: ImageSource.gallery);
              if (file != null) {
                // File(file.path).copy(newPath)
                setState(() {
                  imgFiles.add(file);
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget showImage(int i) {
    return Container(
      key: ValueKey(i),
      height: 63,
      width: 63,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey
                    : Color(0xFF242634),
                blurRadius: 8,
                offset: Offset(0, 4)),
          ],
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
              image: FileImage(File(
                editNote == null || removeAll ? imgFiles[i].path : imgPaths[i],
              )),
              fit: BoxFit.cover)),
      child: editNote == null
          ? GestureDetector(
              key: ValueKey(i),
              onTap: () {
                setState(() {
                  imageOpacity = 1;
                });
                Timer(Duration(seconds: 4), () {
                  setState(() {
                    imageOpacity = 0;
                  });
                });
              },
              child: AnimatedOpacity(
                opacity: imageOpacity,
                duration: Duration(milliseconds: 500),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Visibility(
                    visible: imageOpacity == 0 ? false : true,
                    child: IconButton(
                      icon: Icon(CupertinoIcons.delete_solid),
                      onPressed: () {
                        setState(() {
                          imgFiles.removeAt(i);
                        });
                      },
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addNoteScaffold,
      appBar: AppBar(
        title: Text('How was the day?'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (moodValue != 0) {
              addNote();
              // Navigator.pop(context);
              Navigator.popUntil(context, ModalRoute.withName('home'));
            } else {
              addNoteScaffold.currentState.showSnackBar(SnackBar(
                content: Text('Please select the emoticon that defines'
                    ' your mood throughout the day.'),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(22))),
              ));
            }
          },
          label: Text('Save')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text(
                day[weekDay - 1],
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[100]
                        : Color(0xFF242634),
                    fontSize: 100,
                    fontWeight: FontWeight.w900),
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
            ListView(
              children: <Widget>[
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
                    children: List.generate(
                      6,
                      (i) => SvgEmoji(
                        name: 'emo${i + 1}',
                        moodValue: moodValue,
                        value: i + 1,
                        onSvgTap: () {
                          setState(() {
                            moodValue = i + 1;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Achievements of the day',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey[100]
                                  : Color(0xFF242634),
                              blurRadius: 10)
                        ]),
                    child: editNote == null
                        ? Column(
                            children: List.generate(accLength, (index) {
                              if (index != accLength - 1) {
                                return ListTile(
                                  leading: Icon(FontAwesomeIcons.dotCircle),
                                  title: TextField(
                                    controller: controllers[index],
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
                                      if (controllers.last.text
                                          .trim()
                                          .isNotEmpty) {
                                        controllers
                                            .add(TextEditingController());
                                        setState(() {
                                          accLength++;
                                        });
                                      }
                                    },
                                    child: Icon(CupertinoIcons.add),
                                  ),
                                );
                            }),
                          )
                        : Column(
                            children: List.generate(accLength + 1, (index) {
                              if (index != accLength) {
                                TextEditingController controller =
                                    controllers[index];
                                if (index < editNote.achievements.length)
                                  controller.text =
                                      editNote.achievements[index];
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
                                      if (controllers.last.text
                                          .trim()
                                          .isNotEmpty) {
                                        controllers
                                            .add(TextEditingController());
                                        setState(() {
                                          accLength++;
                                        });
                                      }
                                    },
                                    child: Icon(CupertinoIcons.add),
                                  ),
                                );
                            }, growable: true),
                          ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Description',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey[100]
                                  : Color(0xFF242634),
                              blurRadius: 10)
                        ]),
                    child: TextField(
                      controller: descriptionController,
                      minLines: null,
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Add Images',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                editNote == null || removeAll
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          imgFiles.isNotEmpty
                              ? showImage(0)
                              : addImageButton(0),
                          imgFiles.length > 1
                              ? showImage(1)
                              : addImageButton(1),
                          imgFiles.length > 2
                              ? showImage(2)
                              : addImageButton(2),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(imgPaths.length, (index) {
                          return showImage(index);
                        }),
                      ),
                SizedBox(height: 8),
                editNote != null
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            imgFiles.clear();
                            if (editNote != null) imgPaths.clear();
                            removeAll = true;
                          });
                        },
                        child: Text(
                          'Remove all images',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      )
                    : SizedBox(height: 34),
                SizedBox(height: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SvgEmoji extends StatelessWidget {
  final String name;
  final Function onSvgTap;
  final int value;
  final int moodValue;

  const SvgEmoji(
      {Key key, this.name, this.onSvgTap, this.value, this.moodValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSvgTap,
      child: SvgPicture.asset(
        'assets/images/$name.svg',
        height: 40,
        width: 40,
        color: value == moodValue ? Color(0xffff758c) : null,
      ),
    );
  }
}
//
//class AccomplishedList extends StatelessWidget {
//  final Function onTap;
//
//  const AccomplishedList({Key key, this.onTap}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return ListTile(
//      leading: Icon(FontAwesomeIcons.dotCircle),
//      title: TextField(
//        minLines: null,
//        maxLines: null,
//      ),
//    );
//  }
//}
