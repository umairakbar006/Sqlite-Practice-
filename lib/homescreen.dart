import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      appBar: AppBar(title: Text('Notes'), centerTitle: true),
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
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
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
                        onLongPress: () {
                          titleController.text = snapshot.data![index].title!;
                          descController.text =
                              snapshot.data![index].description!;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Update Note'),
                              content: Column(
                                children: [
                                  TextField(controller: titleController),
                                  TextField(controller: descController),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    dbHelper!
                                        .update(
                                          NotesModel(
                                            id: snapshot.data![index].id,

                                            title: titleController.text,
                                            description: descController.text,
                                          ),
                                        )
                                        .then((Value) {
                                          setState(() {
                                            notesList = dbHelper!
                                                .getNotesList();
                                          });
                                          Navigator.pop(context);
                                        });
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Dismissible(
                          key: Key(snapshot.data![index].id.toString()),
                          background: Container(
                            child: Icon(Icons.delete_sharp),
                            color: Colors.red,
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              dbHelper!.delete(snapshot.data![index].id!);
                              notesList = dbHelper!.getNotesList();
                              snapshot.data!.removeAt(index);
                            });
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(
                                snapshot.data![index].title.toString(),
                              ),
                              subtitle: Text(
                                snapshot.data![index].description.toString(),
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
