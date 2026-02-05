import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/db_handler.dart';
import 'package:notes_app/notes.dart';
import 'package:notes_app/detailscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Added controllers to get input from user

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();

    super.dispose();
  }

  dBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
  @override
  void initState() {
    super.initState();
    dbHelper = dBHelper();
    notesList = dbHelper!.getNotesList();
    loadData();
  }

  loadData() {
    notesList = dbHelper?.getNotesList() ?? Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'MY',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 25,
                ),
              ),
              TextSpan(
                text: ' NOTES',
                style: GoogleFonts.poppins(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: notesList,
            builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                        child: Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              Text(
                                snapshot.data![index].title.toString(),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 5),
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
                      );
                    },
                  ),
                );
              }
              return Text('No data found !!!');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(hintText: 'Enter title'),
                    ),

                    TextField(
                      controller: descController,
                      decoration: InputDecoration(hintText: 'Add decription'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await dbHelper!.insert(
                        NotesModel(
                          title: titleController.text,
                          description: descController.text,
                        ),
                      );
                      titleController.clear();
                      descController.clear();

                      Navigator.pop(context);

                      setState(() {
                        notesList = dbHelper!.getNotesList();
                      });
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add_circle),
      ),
    );
  }
}
