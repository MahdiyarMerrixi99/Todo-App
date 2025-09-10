import 'package:flutter/material.dart';
import 'package:to_do_app/db/notesdb.dart';
import 'package:to_do_app/model/note.dart';
import 'package:to_do_app/screens/add_update.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int doneTasks = 0;
  int allTasks = 0;
  List<Note?> notes = [];
  bool isloading = false;

  Future refreshNotes() async {
    setState(() => isloading = true);
    notes = await NoteDataBase.instance.readAllPosts();
    allTasks = notes.length;
    doneTasks = notes.where((note) => note?.isDone == true).length;
    setState(() => isloading = false);
  }

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUpdate()),
          ).then((_) => refreshNotes());
        },
        child: Icon(Icons.add, size: 20, color: Colors.white),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('mahdiyar'),
                accountEmail: Text('mahdiyar@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                  ),
                ),
              ),
              SizedBox(height: 80),
              ListTileMethod(icon: Icons.delete, title: 'Delete'),
              ListTileMethod(icon: Icons.settings, title: 'Settings'),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, size: 40, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (allTasks == 0) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: Icon(
                      Icons.warning_amber_rounded,
                      size: 30,
                      color: Colors.amber,
                    ),
                    title: Text('Oops!'),
                    content: Text('There is no task to delete.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        child: Text(
                          'Okay',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: Icon(
                      Icons.warning_amber_rounded,
                      size: 30,
                      color: Colors.amber,
                    ),
                    title: Text('Are you sure?'),
                    content: Text('Do you really want to delete all tasks?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.amber),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          for (var note in notes) {
                            await NoteDataBase.instance.deletePost(note!.id);
                          }
                          await refreshNotes();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            icon: Icon(Icons.delete, color: Colors.black, size: 32),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: doneTasks == allTasks && allTasks != 0,
            onChanged: (value) async {
              for (var note in notes) {
                note!.isDone = value!;
                await NoteDataBase.instance.updateNote(note);
              }
              await refreshNotes();
            },
            activeColor: Colors.blue,
            checkboxScaleFactor: 1.5,
            checkboxShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            checkColor: Colors.white,
            title: Text(
              'My Tasks',
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              '$doneTasks of $allTasks tasks',
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ),
          Divider(color: Colors.black54, indent: 70),
          SizedBox(height: 20),
          Expanded(
            child: isloading
                ? Center(child: CircularProgressIndicator())
                : notes.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: 150),
                        Image.network(
                          height: 300,
                          width: 300,
                          fit: BoxFit.cover,
                          'https://img.freepik.com/premium-vector/illustration-task_498740-14038.jpg',
                        ),
                        Text(
                          'No Tasks Yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index]!;
                      return Dismissible(
                        background: Container(
                          color: Colors.red.withOpacity(0.4),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        key: Key(note.id.toString()),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) async {
                          await NoteDataBase.instance.deletePost(note.id);
                          await refreshNotes();
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddUpdate(note: note),
                              ),
                            ).then((_) => refreshNotes());
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                            child: Card(
                              elevation: 16,
                              shadowColor: Colors.black45.withOpacity(0.6),
                              color: Colors.blueAccent,
                              child: Column(
                                children: [
                                  CheckboxListTile(
                                    title: Text(
                                      note.title ?? '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    subtitle: Text(
                                      note.discription ?? '',
                                      style: TextStyle(
                                        color: Colors.black54.withOpacity(0.6),
                                        fontSize: 18,
                                      ),
                                    ),
                                    value: note.isDone,
                                    // onChanged: (value) async {
                                    //   note.isDone = value!;
                                    //   await NoteDataBase.instance.updateNote(
                                    //     note,
                                    //   );
                                    //   await refreshNotes();
                                    // },
                                    onChanged: (value) async {
                                      setState(() {
                                        notes[index]!.isDone = value!;
                                      });

                                      await NoteDataBase.instance.updateNote(
                                        notes[index]!,
                                      );

                                      // فقط doneTasks رو آپدیت می‌کنیم بدون بازخوانی کل لیست
                                      setState(() {
                                        doneTasks = notes
                                            .where((n) => n?.isDone == true)
                                            .length;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ListTileMethod extends StatelessWidget {
  final String title;
  final IconData icon;

  const ListTileMethod({required this.title, super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
    );
  }
}
