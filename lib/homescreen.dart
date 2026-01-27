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
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data![index].title.toString()),
                        subtitle: Text(
                          snapshot.data![index].description.toString(),
                        ),
                        trailing: Text(snapshot.data![index].age.toString()),
                      ),
                    );
                  },
                ),
              );
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
