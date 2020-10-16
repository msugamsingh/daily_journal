import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dailyjournal/models/note.dart';
import 'package:dailyjournal/pages/add_note.dart';
import 'package:dailyjournal/pages/full_screen_image_carousel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  final int index;

  const NoteScreen({Key key, this.note, this.index}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState(note);
}

class _NoteScreenState extends State<NoteScreen> {
  final Note note;
  String date;
  List<Widget> imageSliders = [];

  _NoteScreenState(this.note) {
    date = '${note.dateTime.day}/${note.dateTime.month}/${note.dateTime.year}';

    for (String i in note.imgPaths) {
      imageSliders.add(GestureDetector(
        onLongPress: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FullScreenImageCarousel(imgPaths: note.imgPaths),
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            image: DecorationImage(
              image: FileImage(File(i)),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/emo${note.mood}.svg',
          height: 50,
          width: 50,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNote(
                              editNote: note,
                              editIndex: widget.index,
                            )));
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/images/emo${note.mood}.svg',
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[100]
                  : Color(0xFF242634),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  note.achievements.isNotEmpty ? Text(
                    'Achievements on $date:',
                    style: TextStyle(fontSize: 16),
                  ) : SizedBox(),
                  SizedBox(height: 12),
                  note.achievements.isNotEmpty
                      ? Container(
                          height: 200,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              String data = note.achievements[index];
                              return ListTile(
                                leading: Icon(FontAwesomeIcons.dotCircle),
                                title: Text(data.toString()),
                              );
                            },
                            itemCount: note.achievements.length,
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 12),
                  imageSliders.isNotEmpty
                      ? CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 1.5,
                            enlargeCenterPage: true,
                          ),
                          items: imageSliders,
                        )
                      : SizedBox(),
                  SizedBox(height: 12),
                  note.description.isNotEmpty
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            FontAwesomeIcons.quoteLeft,
                            color: Colors.grey,
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      note.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'pac'),
                    ),
                  ),
                  note.description.isNotEmpty
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            FontAwesomeIcons.quoteRight,
                            color: Colors.grey,
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
