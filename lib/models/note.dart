import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  final int mood;
  @HiveField(1)
  final List<String> achievements;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final List<String> imgPaths;
  @HiveField(4)
  final DateTime dateTime;
  @HiveField(5)
  final bool isFavorite;

  Note(this.mood, this.achievements, this.description, this.imgPaths,
      this.dateTime, this.isFavorite);
}
