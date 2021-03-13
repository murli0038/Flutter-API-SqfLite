import 'package:api_sqflite/Models/Album.dart';
import 'package:api_sqflite/Models/Albums.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper{

  // CREATE THE TABLE COLUMNS
  static Database _db;
  static const String TABLE = "albums";
  static const String ALBUM_ID = "albumId";
  static const String ID = "id";
  static const String TITLE = "title";
  static const String URL = "url";
  static const String THUMBNAIL_URL = "thumbnailUrl";
  static const String DB_NAME = "albums.db";

  //INITIALISE THE DATABASE
  Future<Database> get db async
  {
    if(null != _db){
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async
  {
    // GET THE DEVICE'S DOCUMENT DIRECTORY TO STORE DATA TO OFFLINE DATABASE
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async
  {
    //CREATE THE DATABASE TABLE
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $ALBUM_ID TEXT, $TITLE TEXT, $URL TEXT, $THUMBNAIL_URL TEXT)");
  }

  //METHOD TO INSERT THE ALBUM INTO DATABASE TABLE
  Future<Album> save(Album album) async {
    var dbClient = await db;
    // THIS LINE WILL INSERT THE ALBUM OBJECT TO THE DATABASE AFTER CONVERTING IT TO A JSON
    album.id = await dbClient.insert(TABLE, album.toJson(album));
    return album;
  }

  //METHOD TO FETCH ALL ALBUMS FROM DATABASE
  Future<Albums> getAllAlbums() async {
    var dbClient = await db;
    // SPECIFY THE COLUMN NAMES YOU WANT IN THR RESULT SET
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, TITLE, URL, THUMBNAIL_URL]);
    Albums allAlbums = Albums();
    List<Album> albums = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        albums.add(Album.fromJson(maps[i]));
      }
    }
    allAlbums.albums = albums;
    return allAlbums;
  }

  // METHOD TO DELETE AN ALBUM FROM DATABASE
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  // METHOD TO UPDATE AN ALBUM FROM DATABASE
  Future<int> update(Album album) async {
    var dbClient = await db;
    return await dbClient
        .update(TABLE, album.toJson(album), where: '$ID = ?', whereArgs: [album.id]);
  }

  // METHOD TO TRUNCATE THE TABLE
  Future<void> truncateTable() async {
    var dbClient = await db;
    return await dbClient.delete(TABLE);
  }

  // METHOD TO CLOSE THE DATABASE
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}