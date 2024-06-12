import 'dart:convert';

List<DetectResponse> detectResponseFromMap(List<dynamic> list) =>
    List<DetectResponse>.from(list.map((x) => DetectResponse.fromJson(x)));

String detectResponseToMap(List<DetectResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetectResponse {
  final Box? box;
  final Landmarks? landmarks;
  final double? detectionScore;
  final String? thumbnail;
  final List<Person>? persons;

  DetectResponse({
    this.box,
    this.landmarks,
    this.detectionScore,
    this.thumbnail,
    this.persons,
  });

  DetectResponse copyWith({
    Box? box,
    Landmarks? landmarks,
    double? detectionScore,
    String? thumbnail,
    List<Person>? persons,
  }) =>
      DetectResponse(
        box: box ?? this.box,
        landmarks: landmarks ?? this.landmarks,
        detectionScore: detectionScore ?? this.detectionScore,
        thumbnail: thumbnail ?? this.thumbnail,
        persons: persons ?? this.persons,
      );

  factory DetectResponse.fromJson(Map<String, dynamic> json) => DetectResponse(
        box: json["box"] == null ? null : Box.fromJson(json["box"]),
        landmarks: json["landmarks"] == null
            ? null
            : Landmarks.fromJson(json["landmarks"]),
        detectionScore: json["detection_score"]?.toDouble(),
        thumbnail: json["thumbnail"],
        persons: json["persons"] == null
            ? []
            : List<Person>.from(
                json["persons"]!.map((x) => Person.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "box": box?.toJson(),
        "landmarks": landmarks?.toJson(),
        "detection_score": detectionScore,
        "thumbnail": thumbnail,
        "persons": persons == null
            ? []
            : List<dynamic>.from(persons!.map((x) => x.toJson())),
      };
}

class Box {
  final int? left;
  final int? top;
  final int? right;
  final int? bottom;

  Box({
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  Box copyWith({
    int? left,
    int? top,
    int? right,
    int? bottom,
  }) =>
      Box(
        left: left ?? this.left,
        top: top ?? this.top,
        right: right ?? this.right,
        bottom: bottom ?? this.bottom,
      );

  factory Box.fromJson(Map<String, dynamic> json) => Box(
        left: json["left"],
        top: json["top"],
        right: json["right"],
        bottom: json["bottom"],
      );

  Map<String, dynamic> toJson() => {
        "left": left,
        "top": top,
        "right": right,
        "bottom": bottom,
      };
}

class Landmarks {
  final List<int>? leftEye;
  final List<int>? rightEye;
  final List<int>? nose;
  final List<int>? leftMouth;
  final List<int>? rightMouth;

  Landmarks({
    this.leftEye,
    this.rightEye,
    this.nose,
    this.leftMouth,
    this.rightMouth,
  });

  Landmarks copyWith({
    List<int>? leftEye,
    List<int>? rightEye,
    List<int>? nose,
    List<int>? leftMouth,
    List<int>? rightMouth,
  }) =>
      Landmarks(
        leftEye: leftEye ?? this.leftEye,
        rightEye: rightEye ?? this.rightEye,
        nose: nose ?? this.nose,
        leftMouth: leftMouth ?? this.leftMouth,
        rightMouth: rightMouth ?? this.rightMouth,
      );

  factory Landmarks.fromJson(Map<String, dynamic> json) => Landmarks(
        leftEye: json["left_eye"] == null
            ? []
            : List<int>.from(json["left_eye"]!.map((x) => x)),
        rightEye: json["right_eye"] == null
            ? []
            : List<int>.from(json["right_eye"]!.map((x) => x)),
        nose: json["nose"] == null
            ? []
            : List<int>.from(json["nose"]!.map((x) => x)),
        leftMouth: json["left_mouth"] == null
            ? []
            : List<int>.from(json["left_mouth"]!.map((x) => x)),
        rightMouth: json["right_mouth"] == null
            ? []
            : List<int>.from(json["right_mouth"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "left_eye":
            leftEye == null ? [] : List<dynamic>.from(leftEye!.map((x) => x)),
        "right_eye":
            rightEye == null ? [] : List<dynamic>.from(rightEye!.map((x) => x)),
        "nose": nose == null ? [] : List<dynamic>.from(nose!.map((x) => x)),
        "left_mouth": leftMouth == null
            ? []
            : List<dynamic>.from(leftMouth!.map((x) => x)),
        "right_mouth": rightMouth == null
            ? []
            : List<dynamic>.from(rightMouth!.map((x) => x)),
      };
}

class Person {
  final String? id;
  final String? name;
  final List<Thumbnail>? thumbnails;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? nationality;
  final String? notes;
  final DateTime? createDate;
  final DateTime? modifiedDate;
  final double? score;
  final List<Collection>? collections;

  Person({
    this.id,
    this.name,
    this.thumbnails,
    this.gender,
    this.dateOfBirth,
    this.nationality,
    this.notes,
    this.createDate,
    this.modifiedDate,
    this.score,
    this.collections,
  });

  Person copyWith({
    String? id,
    String? name,
    List<Thumbnail>? thumbnails,
    String? gender,
    DateTime? dateOfBirth,
    String? nationality,
    String? notes,
    DateTime? createDate,
    DateTime? modifiedDate,
    double? score,
    List<Collection>? collections,
  }) =>
      Person(
        id: id ?? this.id,
        name: name ?? this.name,
        thumbnails: thumbnails ?? this.thumbnails,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        nationality: nationality ?? this.nationality,
        notes: notes ?? this.notes,
        createDate: createDate ?? this.createDate,
        modifiedDate: modifiedDate ?? this.modifiedDate,
        score: score ?? this.score,
        collections: collections ?? this.collections,
      );
  factory Person.fromJson(Map<String, dynamic> json) {
    String? personName = json["name"] != null
        ? const Utf8Decoder().convert(json["name"].codeUnits)
        : null;
    String? personNote = json["notes"] != null
        ? const Utf8Decoder().convert(json["notes"].codeUnits)
        : null;

    return Person(
      id: json["id"],
      name: personName ?? json["name"],
      thumbnails: json["thumbnails"] == null
          ? []
          : List<Thumbnail>.from(
              json["thumbnails"]!.map((x) => Thumbnail.fromJson(x)),
            ),
      gender: json["gender"],
      dateOfBirth: json["date_of_birth"] == null
          ? null
          : DateTime.parse(json["date_of_birth"]),
      nationality: json["nationality"],
      notes: personNote ?? json["notes"],
      createDate: json["create_date"] == null
          ? null
          : DateTime.parse(json["create_date"]),
      modifiedDate: json["modified_date"] == null
          ? null
          : DateTime.parse(json["modified_date"]),
      score: json["score"]?.toDouble(),
      collections: json["collections"] == null
          ? []
          : List<Collection>.from(
              json["collections"]!.map((x) => Collection.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnails": thumbnails == null
            ? []
            : List<dynamic>.from(thumbnails!.map((x) => x.toJson())),
        "gender": gender,
        "date_of_birth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "nationality": nationality,
        "notes": notes,
        "create_date": createDate?.toIso8601String(),
        "modified_date": modifiedDate?.toIso8601String(),
        "score": score,
        "collections": collections == null
            ? []
            : List<dynamic>.from(collections!.map((x) => x.toJson())),
      };
}

class Collection {
  final String? id;
  final String? name;
  final String? description;
  final int? count;
  final DateTime? createDate;
  final DateTime? modifiedDate;

  Collection({
    this.id,
    this.name,
    this.description,
    this.count,
    this.createDate,
    this.modifiedDate,
  });

  Collection copyWith({
    String? id,
    String? name,
    String? description,
    int? count,
    DateTime? createDate,
    DateTime? modifiedDate,
  }) =>
      Collection(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        count: count ?? this.count,
        createDate: createDate ?? this.createDate,
        modifiedDate: modifiedDate ?? this.modifiedDate,
      );

  factory Collection.fromJson(Map<String, dynamic> json) {
    String? collectionName = json["name"] != null
        ? const Utf8Decoder().convert(json["name"].codeUnits)
        : null;

    return Collection(
      id: json["id"],
      name: collectionName ?? json["name"],
      description: json["description"],
      count: json["count"],
      createDate: json["create_date"] == null
          ? null
          : DateTime.parse(json["create_date"]),
      modifiedDate: json["modified_date"] == null
          ? null
          : DateTime.parse(json["modified_date"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "count": count,
        "create_date": createDate?.toIso8601String(),
        "modified_date": modifiedDate?.toIso8601String(),
      };
}

class Thumbnail {
  final String? id;
  final String? thumbnail;

  Thumbnail({
    this.id,
    this.thumbnail,
  });

  Thumbnail copyWith({
    String? id,
    String? thumbnail,
  }) =>
      Thumbnail(
        id: id ?? this.id,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        id: json["id"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "thumbnail": thumbnail,
      };
}
