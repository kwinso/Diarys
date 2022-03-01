import 'package:hive/hive.dart';

part 'subject.g.dart';

@HiveType(typeId: 3)
class Subject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int refs;

  Subject(this.name, this.refs);
}
