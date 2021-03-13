import 'package:api_sqflite/Models/Album.dart';

class Albums{
  Albums();

  List<Album> albums;

  factory Albums.fromJson(Map<String,dynamic> json) {
    return Albums()
      ..albums = json['albums'] as List<Album>;
  }

  Map<String, dynamic> toJson(Albums instance) => <String, dynamic> {
    'users' : instance.albums
  };
}