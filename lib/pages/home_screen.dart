import 'dart:io';

import 'package:dailyjournal/models/note.dart';
import 'package:dailyjournal/pages/add_note.dart';
import 'package:dailyjournal/pages/note_screen.dart';
import 'package:dailyjournal/utils/gradient_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koukicons/takeNote2.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box<Note> noteBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteBox = Hive.box('notes');
  }

  void handleOptions(int index, Note note, BuildContext pageCon) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlineButton(
                    child: Icon(Icons.edit),
                    shape: CircleBorder(),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNote(
                              editNote: note,
                              editIndex: index,
                            ),
                          ));
                    }),
                OutlineButton(
                  shape: CircleBorder(),
                  onPressed: () {
                    noteBox.putAt(
                        index,
                        Note(
                          note.mood,
                          note.achievements,
                          note.description,
                          note.imgPaths,
                          note.dateTime,
                          note.isFavorite ? false : true,
                        ));
                    Navigator.pop(context);
                  },
                  child: Icon(
                    note.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color:
                        note.isFavorite ? Theme.of(context).accentColor : null,
                  ),
                ),
                OutlineButton(
                  shape: CircleBorder(),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: pageCon,
                        builder: (context) {
                          return AlertDialog(
                            elevation: 36,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            title: Text('Are you sure?'),
                            content: Text('This note will be deleted.'),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  noteBox.deleteAt(index);
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        });
                  },
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: noteBox.listenable(),
      builder: (BuildContext context, Box<Note> value, Widget child) {
        return value.length != 0
            ? StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: value.length,
                itemBuilder: (BuildContext context, int index) {
                  final Note note = value.getAt(index);
                  var grad = GradientTemplate
                      .gradientTemplate[index % 10].colors; // TODO

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoteScreen(
                                    note: note,
                                    index: index,
                                  )));
                    },
                    onLongPress: () {
                      handleOptions(index, note, context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            colors: grad,
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                          // DecorationImage(
                          //   alignment: Alignment.bottomCenter,
                          //   image: AssetImage(
                          //       'assets/images/namecarddes.png'),
                          //   fit: BoxFit.fill,
                          // )
                          image: note.imgPaths.isEmpty
                              ? null
                              : DecorationImage(
                                  alignment: Alignment.bottomCenter,
                                  image: FileImage(File(note.imgPaths[0])),
                                  colorFilter: ColorFilter.mode(
                                      Colors.black26, BlendMode.darken),
                                  fit: BoxFit.cover,
                                ),
                          boxShadow: [
                            // BoxShadow(color: Colors.grey, blurRadius: 12),
                            BoxShadow(
                              color: grad.last.withOpacity(0.4),
                              blurRadius: 6,
                              offset: Offset(1, 1),
                            ),
                            BoxShadow(
                              color: Color(0xff444974).withOpacity(0.3),
                              blurRadius: 8,
                              // spreadRadius: 2,
                              // offset: Offset(4,4),
                            ),
                          ]),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/emo${note.mood}.svg',
                                    height: 35,
                                    width: 35,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      note.isFavorite
                                          ? Icons.favorite
                                          : FontAwesomeIcons.heart,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    onPressed: () {
                                      noteBox.putAt(
                                          index,
                                          Note(
                                            note.mood,
                                            note.achievements,
                                            note.description,
                                            note.imgPaths,
                                            note.dateTime,
                                            note.isFavorite ? false : true,
                                          ));
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              height: 36,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(18),
                                      bottomRight: Radius.circular(18)),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.black54,
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter)),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '${note.dateTime.day}/${note.dateTime.month}/${note.dateTime.year}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'pac',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 2 : 1),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              )
            : Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KoukiconsTakeNote2(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No notes available.'),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
