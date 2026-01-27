import 'package:flutter/material.dart';
import 'package:notes_app/db_handler.dart';
import 'package:notes_app/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: AppBar(title: Text('Notes Sql'), centerTitle: true),
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
                      return Dismissible(
                        key: Key(snapshot.data![index].id.toString()),
                        background: Container(
                          child: Icon(Icons.delete_sharp),
                          color: Colors.red,
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].title.toString()),
                            subtitle: Text(
                              snapshot.data![index].description.toString(),
                            ),
                            trailing: Text(
                              snapshot.data![index].age.toString(),
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
          dbHelper!
              .insert(
                NotesModel(
                  id: 1,
                  age: 23,
                  title: 'First notes',
                  description: 'This is my first notes',
                  email: 'umairakbar5665',
                ),
              )
              .then((value) {
                print('Notes added');
                setState(() {});
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
