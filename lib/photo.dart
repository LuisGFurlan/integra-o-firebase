class Photo {
  int? id;
  String? uid;
  String? photoName;

  Photo({this.id, this.uid, this.photoName});

  factory Photo.fromMap(Map<String, dynamic> json) => Photo(
        id: json['id'] as int?,
        uid: json['uid'] as String?,
        photoName: json['photo_name'] as String?,
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'uid': uid,
      'photo_name': photoName,  // chave do banco fica com underline
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}
