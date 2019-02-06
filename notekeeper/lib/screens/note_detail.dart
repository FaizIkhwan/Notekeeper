import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget
{
  String appBarTitle;

  NoteDetail(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.appBarTitle);
  }

}

class NoteDetailState extends State<NoteDetail>
{
  static var priorities = ["High", "Low"];

  String appBarTitle;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.subhead;

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

      body: Padding(
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
                  value: priorities[1], // default value
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      // CODE FOR EVENT HANDLER
                      debugPrint("USER SELECTED $valueSelectedByUser");
                    });
                  },
              ),
            ),

            // Second element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint("Something changed in title TextField");
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
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint("Something changed in description TextField");
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
                            // CODE FOR EVENT HANDLER
                            debugPrint("Save button clicked");
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
                            // CODE FOR EVENT HANDLER
                            debugPrint("Delete button clicked");
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
    ));
  }

  void navigateToLastScreen() {
    Navigator.pop(context);
  }

}
