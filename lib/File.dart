import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class Note {
  final String title;
  final String description;

  Note({required this.title, required this.description});

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description};
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      description: json['description'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  late List<Note> _notes;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final file = await _getLocalFile();
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      final List<dynamic> jsonList = json.decode(content);
      _notes = jsonList.map((json) => Note.fromJson(json)).toList();
    } else {
      _notes = [];
    }
    setState(() {});
  }

  Future<void> _saveNote() async {
    final file = await _getLocalFile();
    final note = Note(title: _titleController.text, description: _descController.text);
    _notes.add(note);

    final jsonList = _notes.map((note) => note.toJson()).toList();
    file.writeAsStringSync(json.encode(jsonList));

    _titleController.text = '';
    _descController.text = '';
    _loadNotes();
  }

  Future<void> _deleteNote(int index) async {
    _notes.removeAt(index);
    final file = await _getLocalFile();
    final jsonList = _notes.map((note) => note.toJson()).toList();
    file.writeAsStringSync(json.encode(jsonList));
    _loadNotes();
  }

  Future<void> _editNote(int index) async {
    _titleController.text = _notes[index].title;
    _descController.text = _notes[index].description;
    _deleteNote(index);
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/notes.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: _saveNote,
                  child: Text('Save Note'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _notes.isNotEmpty
                ? ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_notes[index].title),
                        subtitle: Text(_notes[index].description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editNote(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteNote(index),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('No notes available'),
                  ),
          ),
        ],
      ),
    );
  }
}
