import 'package:flutter/material.dart';

import 'notes.dart';

class NoteDetailScreen extends StatelessWidget {
  final NotesModel? note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note!.title!, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black45,
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            Text(
              'Age: ${note!.age}',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${note!.email}',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Divider(height: 30),
            Text(
              'Description: ${note!.description}',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
