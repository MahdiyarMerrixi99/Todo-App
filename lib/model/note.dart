const String tableName = 'notes';

class Note {
  final int? id;
  final String? title;
  final String? discription;
  bool? isDone = false;

  Note({this.id, this.title, this.discription, this.isDone});

  Map<String, Object?> toJson() => {
    NotesFields.id: id,
    NotesFields.title: title,
    NotesFields.discription: discription,
    // NotesFields.isDone: isDone! ? 1 : 0,
    NotesFields.isDone: (isDone ?? false) ? 1 : 0,
  };

  static Note fromJson(Map<String, Object?> json) {
    return Note(
      id: json[NotesFields.id] as int?,
      title: json[NotesFields.title] as String?,
      discription: json[NotesFields.discription] as String,
      isDone: (json[NotesFields.isDone] as int) == 1,
    );
  }

  Note copy({int? id, String? title, String? discription, bool? isDone}) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        discription: discription ?? this.discription,
        isDone: isDone ?? this.isDone,
      );
}

class NotesFields {
  static final List<String> values = [id, title, discription, isDone];

  static const String id = '_id';
  static const String title = '_title';
  static const String discription = '_discription';
  static const String isDone = '_done';
}
