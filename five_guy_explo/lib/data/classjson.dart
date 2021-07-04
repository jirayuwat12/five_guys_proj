class place_list {
  String id = "";
  double lat = 0;
  int like = 0;
  double lon = 0;
  String name = "";
  int unknown = 0;
  String imageUrl = "";

  place_list(
      {required this.id,
      required this.lat,
      required this.like,
      required this.lon,
      required this.name,
      required this.unknown,
      required this.imageUrl});

  place_list.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    like = json['like'];
    lon = json['lon'];
    name = json['name'];
    unknown = json['unknown'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['like'] = this.like;
    data['lon'] = this.lon;
    data['name'] = this.name;
    data['unknown'] = this.unknown;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
