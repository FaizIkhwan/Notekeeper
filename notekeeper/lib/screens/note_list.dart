import 'package:flutter/material.dart';
import './note_detail.dart';

class NoteList extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }

}

class NoteListState extends State<NoteList>
{
  int count = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNoteListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToNoteDetail("Add note");
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  } // build method

  ListView getNoteListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card( //card layout
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right),
            ),

            title: Text("Dummy title", style: titleStyle,),

            subtitle: Text("Dummy subtitle"),

            trailing: Icon(Icons.delete, color: Colors.grey,),

            onTap: () {
              navigateToNoteDetail("Edit note");
            },
          ),
        );
      },
    );
  }

  void navigateToNoteDetail(String title) {

    // code bawah ni untuk nk pergi ke route (activity) lain
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(title);
    }));

  }

}

