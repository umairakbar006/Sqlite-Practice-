class NotesModel {
  final int? id;
  final String? title;
  final String? description;

  NotesModel({this.id, required this.title, required this.description});

  //This is method to save data into database

  Map<String, Object?> toMap() {
    return {'id': id, 'title': title, 'description': description};
  }

  // This method is used to read data from database

  NotesModel.fromMap(Map<String, dynamic> res)
    : id = res['id'],
      title = res['title'],
      description = res['description'];
}
