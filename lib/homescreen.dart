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
//Added controllers to get input from user

final TextEditingController titleController = TextEditingController();
final TextEditingController descController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController emailController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    ageController.dispose();
    emailController.dispose();

    super.dispose();
  }

  DbHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
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
                              snapshot.data!.remove(snapshot.data![index].id);
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
                              trailing: Text(
                                snapshot.data![index].age.toString(),
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
                      controller: ageController,
                      decoration: InputDecoration(hintText: 'Enter Age'),
                    ),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(hintText: 'Add decription'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(hintText: 'Email?'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      dbHelper!
                          .insert(
                            NotesModel(
                              age: int.parse(ageController.text),
                              title: titleController.text,
                              description: descController.text,
                              email: emailController.text,
                            ),
                          )
                          .then((value) {
                            titleController.clear();
                            ageController.clear();
                            descController.clear();
                            emailController.clear();
                            setState(() {
                              notesList = dbHelper!.getNotesList();
                            });
                            Navigator.pop(context);
                          });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Notes added Successfully!!!',
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.red[100],
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
          dbHelper!
              .insert(
                NotesModel(
                  age: 23,
                  title: 'First notes',
                  description: 'This is my first notes',
                  email: 'umairakbar5665',
                ),
              )
              .then((value) {
                print('Notes added');
                setState(() {
                  notesList = dbHelper!.getNotesList();
                });
              })
              .onError((error, StackTrace) {
                print(error.toString());
              });
        },
        child: Icon(Icons.add_circle),
      ),
    );
  }
}
