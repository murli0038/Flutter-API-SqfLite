class Album{
  Album();

  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

  factory Album.fromJson(Map<String, dynamic> json){
    return Album()
        ..albumId = json['albumId'] as int
        ..id = json['id'] as int
        ..title = json['title'] as String
        ..url = json['url'] as String
        ..thumbnailUrl = json['thumbnailUrl'] as String;
  }

  Map<String, dynamic> toJson(Album instance) => <String, dynamic> {
    "albumId": instance.albumId,
    "id": instance.id,
    "title": instance.title,
    "url": instance.url,
    "thumbnailUrl": instance.thumbnailUrl,
  };
}