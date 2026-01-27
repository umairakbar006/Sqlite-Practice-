class NotesModel {
  final int? id;
  final String? title;
  final int? age;
  final String? description;
  final String? email;

  NotesModel({
    this.id,
    required this.age,
    required this.title,
    required this.description,
    required this.email,
  });

  // This method is used to read data from database

  NotesModel.fromMap(Map<String, dynamic> res)
    : id = res['id'],
      title = res['title'],
      age = res['age'],
      description = res['description'],
      email = res['email'];

  //This is method to save data into database

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'age': age,
      'description': description,
      'email': email,
    };
  }
}
