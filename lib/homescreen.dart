import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
            future: dbHelper!.getNotesList(),
            builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Dismissible(
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.center,
                            child: Icon(Icons.delete_outline),
                          ),
                          key: Key(snapshot.data![index].id.toString()),
                          onDismissed: (direction) {
                            dbHelper!.delete(snapshot.data![index].id!);
                            setState(() {
                              dbHelper!.getNotesList();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Note Deleted')),
                            );
                          },

                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteDetailScreen(
                                    note: snapshot.data![index],
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              final currentNote = snapshot.data![index];
                              titleController.text = currentNote.title
                                  .toString();
                              descController.text = currentNote.description
                                  .toString();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: titleController,
                                          decoration: InputDecoration(
                                            label: Text('Edit your Title'),
                                          ),
                                        ),
                                        SizedBox(height: 0.3),
                                        TextField(
                                          controller: descController,
                                          decoration: InputDecoration(
                                            label: Text('Enter Description'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          dbHelper!.update(
                                            NotesModel(
                                              id: snapshot.data![index].id,
                                              title: titleController.text,
                                              description: descController.text,
                                            ),
                                          );
                                          titleController.clear();
                                          descController.clear();
                                          Navigator.pop(context);
                                          setState(() {
                                            notesList = dbHelper!
                                                .getNotesList();
                                          });
                                        },
                                        child: Text('Update'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          titleController.clear();
                                          descController.clear();
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data![index].title
                                              .toString(),
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            int newVal =
                                                snapshot
                                                        .data![index]
                                                        .isFavourite ==
                                                    1
                                                ? 0
                                                : 1;
                                            dbHelper!.update(
                                              NotesModel(
                                                title:
                                                    snapshot.data![index].title,
                                                description: snapshot
                                                    .data![index]
                                                    .description,
                                                isFavourite: newVal,
                                              ),
                                            );
                                            setState(() {
                                              dbHelper!.getNotesList();
                                            });
                                          },
                                          icon: Icon(
                                            snapshot.data![index].isFavourite ==
                                                    1
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                snapshot
                                                        .data![index]
                                                        .isFavourite ==
                                                    1
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Divider(thickness: 0.5),
                                    Expanded(
                                      child: Text(
                                        snapshot.data![index].description
                                            .toString(),
                                        style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),

                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
