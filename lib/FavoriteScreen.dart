import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/db_handler.dart';
import 'package:notes_app/detailscreen.dart';
import 'package:notes_app/notes.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  dBHelper? dbhelper;
  late Future<List<NotesModel>> favNotesList;
  @override
  void initState() {
    dbhelper = dBHelper();
    favNotesList = dbhelper!.getFavNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'FAVORITES',
          style: GoogleFonts.poppins(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: favNotesList,
        builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: $Error');
          } else if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NoteDetailScreen(note: snapshot.data![index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    key: Key(snapshot.data![index].id.toString()),
                    child: ListTile(
                      title: Column(
                        children: [
                          Text(
                            snapshot.data![index].title.toString(),
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(thickness: 0.5),
                          Text(
                            snapshot.data![index].description.toString(),
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),

                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Text('No Fav Notes Found');
          }
        },
      ),
    );
  }
}
