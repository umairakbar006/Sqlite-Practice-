import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notes.dart';

class NoteDetailScreen extends StatelessWidget {
  final NotesModel? note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          '${note!.title}',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            Container(
              child: Center(
                child: Text(
                  '${note!.description}',
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
