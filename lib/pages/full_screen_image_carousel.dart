import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FullScreenImageCarousel extends StatelessWidget {
  final List<String> imgPaths;

  // List<Widget> images = [];

  const FullScreenImageCarousel({Key key, this.imgPaths}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Builder(
        builder: (BuildContext context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
            ),
            items: imgPaths
                .map((item) => Container(
                      child: Center(
                          child: Image.file(
                        File(item),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        height: height,
                      )),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
