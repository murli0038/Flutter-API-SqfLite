import 'package:api_sqflite/Models/Album.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumGrid extends StatelessWidget {

  @required
  final Album album;
  final Function onUpdate;
  final Function onDelete;
  const AlbumGrid({Key key, this.album, this.onUpdate, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(album.url.toString()),
            fit: BoxFit.cover
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){
                    album.title = "${album.id} updated";
                    onUpdate(album);
                },icon: Icon(Icons.update),),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "${album.id}",
                    maxLines: 1,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: (){
                  onDelete(album.id);},
                  icon: Icon(Icons.delete),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
