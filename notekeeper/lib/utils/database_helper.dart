import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notekeeper/models/note.dart';

class DatabaseHelper
{
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper (in app life cycle, only 1 is created)
  static Database _database; // Singleton Database

  // table and column
  String noteTable = "note_table";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  // factory untuk bagi return dalam constructor
  factory DatabaseHelper()
  {
    if(_databaseHelper == null) // only executed once
      _databaseHelper = DatabaseHelper._createInstance();

    return _databaseHelper;
  }

  Future<Database> get database async {

    if(_database == null)
      _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "notes.db";

    // open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    String sql = "CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)";
    await db.execute(sql);
  }

  // Fetch Operation : Get all Note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {

    Database db = await this.database;

//    var result = await db.rawQuery("SELECT * FROM $noteTable order by $colPriority ASC"); // raw query
    var result = await db.query(noteTable, orderBy: "$colPriority ASC");
    return result;
  }

  // Insert Operation : Insert a Note object to database

  // Update Operation : Update a Note object and save it to database

  // Delete Operation : Delete a Note object from database

  // Get number of Note object in database
}
