import 'package:diarys/state/types/subject.dart';
import 'package:hive/hive.dart';

part 'subjects_list.g.dart';

// Need to use this wrapper because of Hive limitations on Generic types
@HiveType(typeId: 4)
class SubjectsList {
  @HiveField(0)
  List<Subject> list;

  SubjectsList(this.list);
}
