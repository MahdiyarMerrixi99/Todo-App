import 'package:flutter/material.dart';
import 'package:to_do_app/db/notesdb.dart';
import 'package:to_do_app/model/note.dart';

class AddUpdate extends StatefulWidget {
  final Note? note;
  const AddUpdate({super.key, this.note});

  @override
  State<AddUpdate> createState() => _AddUpdateState();
}

class _AddUpdateState extends State<AddUpdate> {
  final formKey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    title = widget.note?.title ?? '';
    description = widget.note?.discription ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 100),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Divider(color: Colors.black, endIndent: 10)),
              RichText(
                text: TextSpan(
                  text: 'Add New',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  children: [
                    TextSpan(
                      text: ' Task',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Divider(color: Colors.black.withOpacity(0.4))),
            ],
          ),
          SizedBox(height: 20),

          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                SizedBox(width: 30),
                Text(
                  'what are you planning?',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: widget.note?.discription ?? '',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'The title cannot be empty';
                      }
                      return null;
                    },

                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ), // بردر پایین
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ), // وقتی غیرفعاله
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ), // وقتی فوکوسه
                      ),
                      prefixIcon: Column(
                        children: [Icon(Icons.save, size: 32)],
                      ),
                      hint: Text(
                        'add your task',

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    initialValue: widget.note?.discription ?? '',
                    maxLines: 6,
                    onChanged: (value) {
                      description = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'The description cannot be empty';
                      }
                      return null;
                    },

                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ), // بردر پایین
                      ),
                      prefixIcon: Column(
                        children: [Icon(Icons.description, size: 32)],
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ), // وقتی غیرفعاله
                      ),

                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ), // وقتی فوکوسه
                      ),
                      hint: Text(
                        'desicription',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ElevatedButton.icon(
            iconAlignment: IconAlignment.end,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),

              elevation: 16,
              padding: EdgeInsets.all(10),
              backgroundColor: Colors.blue,
              textStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: saveButton,
            label: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            icon: Icon(Icons.save, color: Colors.white),
          ),
        ],
      ),
    );
  }

  saveButton() async {
    final isValid = formKey.currentState?.validate();
    if (isValid == true) {
      final navigator = Navigator.of(context);
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await updateMethode();
      } else {
        await addNote();
      }
      navigator.pop();
    }
  }

  addNote() async {
    final note = Note(title: title, discription: description);
    await NoteDataBase.instance.creat(note);
  }

  updateMethode() async {
    final updateNote = widget.note?.copy(
      discription: description,
      title: title,
    );
    await NoteDataBase.instance.updateNote(updateNote!);
  }
}
