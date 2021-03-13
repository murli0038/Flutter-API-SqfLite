import 'package:api_sqflite/DataBase/DBHepler.dart';
import 'package:api_sqflite/Models/Album.dart';
import 'package:api_sqflite/Models/Albums.dart';
import 'package:api_sqflite/Screens/AlbumGrid.dart';
import 'package:api_sqflite/Services/Services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static Albums albums;
  int counter;
  DBHelper dbHelper;
  bool isAlbumLoad;
  String title = "ALBUMS FROM SQFLITE";     // APPBAR TITLE
  double percent;   //SHOWING THE PROGRESS
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    isAlbumLoad = false;
    counter = 0;
    percent = 0.0;
    dbHelper = DBHelper();
    scaffoldKey = GlobalKey();
    dbHelper.getAllAlbums().then((albumsFromDatabase){
      setState(() {
        albums = albumsFromDatabase;
        isAlbumLoad = true;
      });

    });
  }

  getAlbums(){
    setState(() {
      counter = 0;
      isAlbumLoad = false;
    });
    Services.getPhotos().then((albumsFromURL){
        albums = albumsFromURL;
        // HERE WE GOT ALL ALBUMS FROM URL
        // WE WILL INSERT EACH ALBUM ONE BY ONE INTO DATABASE
        //ON EACH LOAD WE TRUNCATE THE TABLE
      dbHelper.truncateTable().then((value) => {
        //WRITE A RECURSIVE FUNCTION TO INSERT ALL ALBUMS
        insertAlbums(albums.albums[0])
      });

    });
  }

  insertAlbums(Album album){
    dbHelper.save(album).then((value){
      counter++;
      percent = ((counter/albums.albums.length) * 100) / 100;
      //FINISH THIS FUNCTION EXECUTION AFTER AT THE END OF ALBUM
      if(counter >= albums.albums.length){
        //THIS WILL GETTING DONE LOAD THE ALBUMS
        setState(() {
          isAlbumLoad = true;
          percent = 0.0;
          title = "ALBUMS FROM URL ${counter}";
        });
        return;
      }
      setState(() {
        title = "INSERTING TO DATABASE : $counter";
      });
      Album a = albums.albums[counter];
      insertAlbums(a);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(title,style: TextStyle(fontSize: 15),),
        actions: [
          IconButton(icon: Icon(Icons.file_download), onPressed: (){getAlbums();})
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isAlbumLoad
              ? Flexible(
            child: FutureBuilder<Albums>(
              future: dbHelper.getAllAlbums(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  // print(snapshot.data.albums.length);
                  // return Text("OK");
                  return gridForAlbum(snapshot);
                }
                // if still loading return an empty container
                return Container();
              },
            ),
          ) : LinearProgressIndicator(value: percent,),
        ],
      ),
    );
  }

  gridForAlbum(AsyncSnapshot<Albums> snapshot) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: snapshot.data.albums.map((album) {
          return GridTile(
            child: AlbumGrid(album: album,onDelete: delete,onUpdate: update,),
          );
        }).toList(),
      ),
    );
  }

  // Update Function
  update(Album album) {
    // We are updating the album title on each update
    dbHelper.update(album).then((updtVal) {
      showSnackBar('Updated ${album.id}');
      refresh();
    });
  }

  // Delete Function
  delete(int id) {
    dbHelper.delete(id).then((delVal) {
      showSnackBar('Deleted $id');
      refresh();
    });
  }

  // Method to refresh the List after the DB Operations
  refresh() {
    dbHelper.getAllAlbums().then((allAlbums) {
      setState(() {
        albums = allAlbums;
        counter = albums.albums.length;
        title = 'ALBUMS FROM SQFLITE [$counter]'; // updating the title
      });
    });
  }

  // Show a Snackbar
  showSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

}
