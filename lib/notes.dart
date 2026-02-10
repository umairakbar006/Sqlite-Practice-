class NotesModel {
  final int? id;
  final String? title;
  final String? description;
  final int? isFavourite;
  // Constructor
  NotesModel({
    this.id,
    required this.title,
    required this.description,
    this.isFavourite = 0,
  });
  // This method is used to read data from database

  NotesModel.fromMap(Map<String, dynamic> res)
    : id = res['id'],
      title = res['title'],
      description = res['description'],
      isFavourite = res['isFavourite'];

  //This is method to save data into database

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isFavourite': isFavourite,
    };
  }
}
