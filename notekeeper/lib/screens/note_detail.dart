import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';

class NoteDetail extends StatefulWidget
{
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }

}

class NoteDetailState extends State<NoteDetail>
{
  var formKey = GlobalKey<FormState>();

  static var priorities = ["High", "Low"];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    // tunjuk yg note asal (kalau bukan baru)
    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(

      onWillPop: () {
        // to manually navigate back navigation button in device
        navigateToLastScreen();
      },

      child: Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(icon: Icon(
            Icons.arrow_back
        ),
            onPressed: () {
              navigateToLastScreen();
            }
        ),
      ),

      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[

              // First element
              ListTile(
                title: DropdownButton(
                  items: priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String> (
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem)
                    );
                  }).toList(),
                  style: textStyle,
                  value: getPriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      updatePriorityAsInt(valueSelectedByUser);
                    });
                  },
                ),
              ),

              // Second element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: titleController,
                  style: textStyle,
                  validator: (String text) {
                    if(text.isEmpty)
                      return "Please enter title";
                  },
                  decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
              ),

              // Third element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: descriptionController,
                  style: textStyle,
                  validator: (String text) {
                    if(text.isEmpty)
                      return "Please enter description";
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
              ),

              // Fourth element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded( // untuk equal space
                      child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Save",
                            textScaleFactor: 1.5, // 50% bigger
                          ),
                          onPressed: () {
                            setState(() {
                              if(formKey.currentState.validate()) // untuk validator function
                                _save();
                            });
                          }
                      ),
                    ),

                    Container(width: 5.0,), // spacing antara 2 button

                    Expanded( // untuk equal space
                      child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Delete",
                            textScaleFactor: 1.5, // 50% bigger
                          ),
                          onPressed: () {
                            setState(() {
                              _delete();
                            });
                          }
                      ),
                    )

                  ],
                ),
              )

            ],
          ),
        ),
      ),
    ));
  }

  void navigateToLastScreen() {
    Navigator.pop(context, true); // pass true kat navigator notelist
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch(value)
    {
      case "High":
        note.priority = 1;
        break;
      case "Low":
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch(value) {
      case 1:
        priority = "High";
        break;
      case 2:
        priority = "Low";
        break;
    }

    return priority;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {

    updateTitle();
    updateDescription();

    navigateToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null) { // Case 1 : Update operation
      result = await helper.updateNote(note);
    } else { // Case 2 : Insert operation
      result = await helper.insertNode(note);
    }

    if(result != 0) { // Success
      _showAlertDialog("Status", "Note saved successfully");
    } else { // Fail
      _showAlertDialog("Status", "Problem saving note");
    }
  }

  void _delete() async{

    navigateToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if(note.id == null) {
      _showAlertDialog("Status", "No note was deleted");
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if(result != 0) { // Success
      _showAlertDialog("Status", "Note deleted successfully");
    } else { // Fail
      _showAlertDialog("Status", "Error occured while deleting note");
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message)
    );
    
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }

}
