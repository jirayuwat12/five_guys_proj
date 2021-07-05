import 'package:http/http.dart' as http;
import 'dart:convert';

class Place {
  String id = "";

  String name = "";

  String imageUrl = "";

  /// amount of people that mark this place as unknown for them.
  int unknown = 0;

  /// latitude
  double lat = 0;

  /// longitude
  double lon = 0;

  List<Comment> comments = [];

  Place(
      {required String id,
      required String name,
      required String imageUrl,
      required int unknown,
      required double lat,
      required double lon,
      required List<Comment> comments}) {
    this.id = id;
    this.name = name;
    this.imageUrl = imageUrl;
    this.unknown = unknown;
    this.lat = lat;
    this.lon = lon;
    this.comments = comments;
  }

  @override
  String toString() {
    return 'Place[lat=$lat, lon=$lon, name=$name, imageUrl=$imageUrl, unknown=$unknown, id=$id, comment=${comments.toString()}]';
  }
}

class Comment {
  String userName = '';

  String text = '';

  String avatarUrl = '';

  String id = '';

  /// the date of the comment stored as milliseconds from 1 January 1970.
  int date = 0;

  int like = 0;

  Comment(
      {required String userName,
      required String avatarUrl,
      required String text,
      required int date,
      required int like,
      required String id}) {
    this.userName = userName;
    this.avatarUrl = avatarUrl;
    this.text = text;
    this.date = date;
    this.like = like;
    this.id = id;
  }

  @override
  String toString() {
    return 'Comment[userName=$userName, avatarUrl=$avatarUrl, text=$text, date=$date, like=$like, id=$id]';
  }
}

Comment commentFromJson(dynamic comment) {
  return Comment(
    avatarUrl: comment['avatar_url'],
    date: comment['date'],
    id: comment['id'],
    like: comment['like'],
    text: comment['text'],
    userName: comment['user_name'],
  );
}

List<Comment> commentsFromJson(dynamic data) {
  return data.map<Comment>((comment) => commentFromJson(comment)).toList();
}

Place placeFromJson(dynamic place) {
  return Place(
      id: place['id'],
      name: place['name'],
      lat: place['lat'],
      lon: place['lon'],
      unknown: place['unknown'],
      imageUrl: place['image_url'],
      comments: commentsFromJson(place['comments']));
}

List<Place> placesFromJson(dynamic data) {
  return data.map<Place>((place) => placeFromJson(place)).toList();
}

Future<List<Place>> getPlaces(List<String> toIgnore) async {
  var response = await http.get(Uri.parse(
      'https://twt-fiveguys-6-2021.herokuapp.com/places?ignore=${toIgnore.join(',')}'));
  var data = jsonDecode(response.body);
  return placesFromJson(data);
}

Future<List<Place>> getPlacesByID(List<String> id) async {
  var response = await http.get(Uri.parse(
      'https://twt-fiveguys-6-2021.herokuapp.com/places?id=${id.join(',')}'));
  var data = jsonDecode(response.body);
  return placesFromJson(data);
}

Future<List<Place>> getTopPlaces() async {
  var response = await http
      .get(Uri.parse('https://twt-fiveguys-6-2021.herokuapp.com/top'));
  var data = jsonDecode(response.body);
  return placesFromJson(data);
}

Future<String> comment(
    {required String userName,
    required int date,
    required String text,
    required String placeID,
    required String avatarUrl}) async {
  var response = await http.get(Uri.parse(
      'https://twt-fiveguys-6-2021.herokuapp.com/comments?user_name=$userName&date=$date&text=$text&place_id=$placeID&avatar_url=$avatarUrl'));
  return jsonDecode(response.body)['id'];
}

/// Add value to the comment with the given id likes (value = 1 for liking, value = -1 for unliking)
void like(String id, int value) {
  http.post(Uri.parse(
      'https://twt-fiveguys-6-2021.herokuapp.com/like?id=$id&val=$value'));
}

/// Increment the unknown user count of the place with the given id
void unknown(String id) {
  var response = http.post(
      Uri.parse('https://twt-fiveguys-6-2021.herokuapp.com/unknown?id=$id'));
  response.then((value) => print(value.statusCode));
}
